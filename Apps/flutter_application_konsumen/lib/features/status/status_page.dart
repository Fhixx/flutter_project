import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/session/user_session.dart';
import 'package:http/http.dart' as http;

import '../../../core/styles/app_text_styles.dart';
import '../../../core/theme/app_colors.dart';

class OrderStatusPage extends StatefulWidget {
  final int userId;
  const OrderStatusPage({super.key, required this.userId});

  @override
  State<OrderStatusPage> createState() => _OrderStatusPageState();
}

class _OrderStatusPageState extends State<OrderStatusPage> {
  List orders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  final userId = UserSession.id;
  Future<void> fetchOrders() async {
    try {
      final response = await http.get(
        Uri.parse("http://10.0.2.2:8000/orders/user/$userId"),
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

  Color getStatusColor(String status) {
    switch (status) {
      case "menunggu_verifikasi":
        return Colors.orange;
      case "diproses":
        return Colors.blue;
      case "dikirim":
        return Colors.purple;
      case "selesai":
        return Colors.green;
      case "ditolak":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String formatStatus(String status) {
    switch (status) {
      case "menunggu_verifikasi":
        return "Menunggu Verifikasi";
      case "diproses":
        return "Diproses";
      case "dikirim":
        return "Dikirim";
      case "selesai":
        return "Selesai";
      case "ditolak":
        return "Ditolak";
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F8FC),
      body: SafeArea(
        child: Column(
          children: [
            /// HEADER
            Container(
              width: double.infinity,

              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
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
                    "Status Pesanan",
                    style: AppTextStyles.title.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),

            /// CONTENT
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: fetchOrders,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: orders.length,
                        itemBuilder: (context, index) {
                          final order = orders[index];

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: const [
                                BoxShadow(color: Colors.black12, blurRadius: 6),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// ID ORDER
                                Text(
                                  "Order #${order["id"]}",
                                  style: AppTextStyles.title,
                                ),

                                const SizedBox(height: 8),

                                /// TOTAL
                                Text(
                                  "Total: Rp ${order["total"]}",
                                  style: AppTextStyles.subtitle,
                                ),

                                const SizedBox(height: 8),

                                // NAMA PRODUK
                                Text(
                                  "Produk: ${order["product_name"]}",
                                  style: AppTextStyles.subtitle,
                                ),

                                const SizedBox(height: 4),

                                // JUMLAH
                                Text(
                                  "Jumlah: ${order["qty"]}",
                                  style: AppTextStyles.subtitle,
                                ),

                                const SizedBox(height: 8),

                                /// STATUS
                                Row(
                                  children: [
                                    const Text("Status: "),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: getStatusColor(
                                          order["status"],
                                        ).withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        formatStatus(order["status"]),
                                        style: TextStyle(
                                          color: getStatusColor(
                                            order["status"],
                                          ),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 8),

                                /// ALAMAT
                                Text(
                                  "Alamat: ${order["alamat_kirim"]}",
                                  style: AppTextStyles.subtitle,
                                ),

                                if (order["catatan"] != null &&
                                    order["catatan"] != "")
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text(
                                      "Catatan: ${order["catatan"]}",
                                      style: AppTextStyles.subtitle,
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
