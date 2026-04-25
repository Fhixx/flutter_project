import 'package:flutter/material.dart';

import '../../../core/styles/app_text_styles.dart';
import '../models/order_model.dart';
import '../models/courier_model.dart';
import '../services/courier_service.dart';

class DeliveryPage extends StatefulWidget {
  const DeliveryPage({super.key});

  @override
  State<DeliveryPage> createState() => _DeliveryPageState();
}

class _DeliveryPageState extends State<DeliveryPage> {
  List<OrderModel> orders = [];
  List<CourierModel> couriers = [];

  Map<int, int?> selectedCourier = {};

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  // LOAD DATA API
  Future<void> loadData() async {
    try {
      final orderData = await ApiService.getOrders();
      final courierData = await ApiService.getCouriers();

      setState(() {
        orders = orderData;
        couriers = courierData;
        isLoading = false;
      });
    } catch (e) {
      print("ERROR: $e");

      setState(() {
        isLoading = false;
      });
    }
  }

  // UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F8FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF7BC148),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Penugasan Karyawan"),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),

      // BODY
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : orders.isEmpty
            ? const Center(child: Text("Tidak ada pesanan"))
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final o = orders[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ORDER ID
                        Text(
                          "#ORD${o.orderId}",
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),

                        // NAMA
                        Text(
                          o.nama,
                          style: AppTextStyles.homeGreeting.copyWith(
                            color: Colors.black,
                          ),
                        ),

                        const SizedBox(height: 8),

                        // DETAIL
                        Text("Produk: ${o.produk}"),
                        Text("Jumlah: ${o.jumlah}"),
                        Text("Alamat: ${o.alamat}"),

                        const SizedBox(height: 12),

                        // DROPDOWN COURIER
                        DropdownButtonFormField<int>(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFFF3F3F5),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          hint: const Text("Pilih Karyawan"),
                          initialValue: selectedCourier[o.orderId],
                          items: couriers.map((c) {
                            return DropdownMenuItem<int>(
                              value: c.id,
                              child: Text(c.nama),
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() {
                              selectedCourier[o.orderId] = val;
                            });
                          },
                        ),

                        const SizedBox(height: 12),

                        // BUTTON ASSIGN
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: selectedCourier[o.orderId] == null
                                ? null
                                : () async {
                                    final success =
                                        await ApiService.assignCourier(
                                          o.orderId,
                                          selectedCourier[o.orderId]!,
                                        );

                                    if (success) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Kurir berhasil ditugaskan",
                                          ),
                                        ),
                                      );
                                      await loadData();
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text("Gagal assign kurir"),
                                        ),
                                      );
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF7BC148),
                              foregroundColor: Colors.white, 
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text("Pilih Kurir"),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
