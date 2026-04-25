import 'package:flutter/material.dart'; 
import '../services/courier_service.dart';

class OrderDetailPage extends StatefulWidget {
  final int orderId;

  const OrderDetailPage({super.key, required this.orderId});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  Map<String, dynamic>? data;
  bool isLoading = true;

  final TextEditingController codController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final res = await ApiService.getDetail(widget.orderId);

    setState(() {
      data = res;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final o = data!;

    final status = o['status']?.toString().toLowerCase().trim();
    final metode = o['metode']?.toString().toLowerCase().trim();
    final statusPembayaran =
        o['status_pembayaran']?.toString().toLowerCase().trim();

    return Scaffold(
      backgroundColor: const Color(0xFFF2F8FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF7BC148),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Detail Tugas"),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            /// STATUS ORDER
            _sectionCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Status"),
                  Text(
                    status!.toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// STATUS PEMBAYARAN (COD)
            if (metode == "cod")
              _sectionCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Pembayaran"),
                    Text(
                      statusPembayaran == "dibayar"
                          ? "SUDAH BAYAR"
                          : "BELUM BAYAR",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: statusPembayaran == "dibayar"
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 16),

            /// LOKASI AMBIL
            if (status != 'dikirim' && status != 'selesai')
              _sectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Lokasi Ambil"),
                    SizedBox(height: 6),
                    Text(
                      "Gudang Pusat (Dummy)",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 16),

            /// DETAIL ORDER
            _sectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Detail Pesanan"),
                  const SizedBox(height: 10),
                  Text("Nama: ${o['nama']}"),
                  Text("Produk: ${o['produk']}"),
                  Text("Jumlah: ${o['qty']}"),
                  Text("Alamat: ${o['alamat_kirim']}"),
                  Text("Telepon: ${o['telepon']}"),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// CATATAN
            if (o['catatan'] != null && o['catatan'] != "")
              _sectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Catatan"),
                    const SizedBox(height: 6),
                    Text(o['catatan']),
                  ],
                ),
              ),

            const SizedBox(height: 20),

            /// BUTTON AREA
            _buildActionButton(status, metode, statusPembayaran, o),
          ],
        ),
      ),
    );
  }

  // ================= BUTTON =================

  Widget _buildActionButton(
    String status,
    String? metode,
    String? statusPembayaran,
    Map<String, dynamic> o,
  ) {
    /// 1. AMBIL BARANG
    if (status != "dikirim" && status != "selesai") {
      return _mainButton(
        text: "Ambil Barang",
        onPressed: () async {
          await ApiService.pickup(widget.orderId);
          loadData();
        },
      );
    }

    /// 2. QRIS → LANGSUNG SELESAI
    if (metode == "qris" && status == "dikirim") {
      return _mainButton(
        text: "Selesaikan Pesanan",
        onPressed: () async {
          await ApiService.finish(widget.orderId);
          loadData();
        },
      );
    }

    /// 3. COD FLOW
    if (metode == "cod" && status == "dikirim") {
      final total = o['jumlah'] ?? 0;

      /// auto isi input
      codController.text = total.toString();

      return Column(
        children: [
          /// TOTAL COD
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              "Total COD: Rp $total",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.orange,
              ),
            ),
          ),

          /// BELUM BAYAR
          if (statusPembayaran != "dibayar") ...[
            TextField(
              controller: codController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Masukkan uang COD",
                filled: true,
                fillColor: const Color(0xFFF3F3F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 12),

            _mainButton(
              text: "Upload Pembayaran COD",
              onPressed: () async {
                if (codController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Masukkan jumlah uang")),
                  );
                  return;
                }

                if (int.parse(codController.text) != total) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Jumlah harus sesuai tagihan"),
                    ),
                  );
                  return;
                }

                await ApiService.bayarCOD(
                  widget.orderId,
                  int.parse(codController.text),
                );

                loadData();
              },
            ),
          ],

          /// SUDAH BAYAR
          if (statusPembayaran == "dibayar") ...[
            const SizedBox(height: 12),
            _mainButton(
              text: "Selesaikan Pesanan",
              onPressed: () async {
                await ApiService.finish(widget.orderId);
                loadData();
              },
            ),
          ],
        ],
      );
    }

    return const SizedBox();
  }

  // ================= UI =================

  Widget _sectionCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _mainButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF7BC148),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(text),
      ),
    );
  }
}

