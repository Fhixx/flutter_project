import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../core/styles/app_text_styles.dart';
import '../../../core/theme/app_colors.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  List orders = [];
  bool isLoading = true;

  String currentStatus = "menunggu_verifikasi";

  @override
  void initState() {
    super.initState();
    fetchOrders(currentStatus);
  }

  /// FETCH
  Future<void> fetchOrders(String status) async {
    setState(() {
      isLoading = true;
      currentStatus = status;
    });

    try {
      final response = await http.get(
        Uri.parse("http://10.0.2.2:8000/verification/$status"),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          orders = data;
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error: $e");
      setState(() => isLoading = false);
    }
  }

  /// APPROVE
  Future<void> approveOrder(int id) async {
    final response = await http.put(
      Uri.parse("http://10.0.2.2:8000/verification/approve/$id"),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Pesanan disetujui")));

      fetchOrders(currentStatus);
    }
  }

  /// REJECT
  Future<void> rejectOrder(int id) async {
    final response = await http.put(
      Uri.parse("http://10.0.2.2:8000/verification/reject/$id"),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Pesanan ditolak")));

      fetchOrders(currentStatus);
    }
  }

  /// CARD
  Widget buildCard(order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Order #${order["id"]}", style: AppTextStyles.title),
          const SizedBox(height: 8),

          Text(
            "Produk: ${order["product_name"]}",
            style: AppTextStyles.subtitle,
          ),

          Text("Jumlah: ${order["qty"]}", style: AppTextStyles.subtitle),

          Text("Total: Rp ${order["total"]}", style: AppTextStyles.subtitle),

          Text(
            "Alamat: ${order["alamat_kirim"]}",
            style: AppTextStyles.subtitle,
          ),

          const SizedBox(height: 12),

          /// BUTTON HANYA DI TAB VERIFIKASI
          if (currentStatus == "menunggu_verifikasi")
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => approveOrder(order["id"]),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Setujui"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => rejectOrder(order["id"]),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Tolak"),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  /// BUILD
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFF2F8FC),

        body: SafeArea(
          child: Column(
            children: [
              /// HEADER
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryDark],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Monitoring Pesanan",
                      style: AppTextStyles.title.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              /// TAB BAR (CARD STYLE)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16), 
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 6),
                    ],
                  ),
                  child: TabBar(
                    indicator: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(
                        14,
                      ), // ✅ indicator ikut rounded
                    ),
                    labelColor: Colors.white, // aktif
                    unselectedLabelColor: Colors.black54, // non aktif
                    indicatorSize: TabBarIndicatorSize.tab,
                    onTap: (index) {
                      if (index == 0) {
                        fetchOrders("menunggu_verifikasi");
                      } else if (index == 1) {
                        fetchOrders("diproses");
                      } else {
                        fetchOrders("ditolak");
                      }
                    },
                    tabs: const [
                      Tab(text: "Verifikasi"),
                      Tab(text: "Diproses"),
                      Tab(text: "Ditolak"),
                    ],
                  ),
                ),
              ),

              /// CONTENT
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : orders.isEmpty
                    ? const Center(child: Text("Tidak ada data"))
                    : RefreshIndicator(
                        onRefresh: () => fetchOrders(currentStatus),
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: orders.length,
                          itemBuilder: (context, index) {
                            return buildCard(orders[index]);
                          },
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
