import 'package:flutter/material.dart'; 
import '../../../core/styles/app_text_styles.dart'; 
import '../../../core/theme/app_colors.dart'; 
import '../models/order_model.dart'; 
import '../services/courier_service.dart'; 
import 'detail_page.dart';

class CourierOrdersPage extends StatefulWidget {
  final int courierId;

  const CourierOrdersPage({super.key, required this.courierId});

  @override
  State<CourierOrdersPage> createState() => _CourierOrdersPageState();
}

class _CourierOrdersPageState extends State<CourierOrdersPage>
    with SingleTickerProviderStateMixin {
  List<OrderModel> orders = [];
  bool isLoading = true;

  late int courierId;
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    courierId = widget.courierId;
    tabController = TabController(length: 2, vsync: this);
    loadData();
  }

  Future<void> loadData() async {
    final data = await ApiService.getCourierOrders(courierId);

    if (!mounted) return;

    setState(() {
      orders = data;
      isLoading = false;
    });
  }

  /// FILTER DATA
  List<OrderModel> get prosesOrders {
    return orders.where((o) {
      final status = o.statusPengiriman?.toLowerCase() ?? "";
      return status == "menunggu" || status == "dikirim";
    }).toList();
  }

  List<OrderModel> get selesaiOrders {
    return orders.where((o) {
      final status = o.statusPengiriman?.toLowerCase() ?? "";
      return status == "selesai";
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F8FC),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF7BC148),
        title: const Text("Order Kurir"),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),

      

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
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
                      controller: tabController,
                      dividerColor: Colors.transparent,
                      indicator: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.black54,
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelStyle:
                          const TextStyle(fontWeight: FontWeight.bold),
                      tabs: const [
                        Tab(text: "Proses"),
                        Tab(text: "Selesai"),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                /// CONTENT
                Expanded(
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      _buildList(prosesOrders),
                      _buildList(selesaiOrders),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  /// LIST
  Widget _buildList(List<OrderModel> list) {
    return RefreshIndicator(
      onRefresh: loadData,
      child: list.isEmpty
          ? const Center(child: Text("Tidak ada data"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: list.length,
              itemBuilder: (context, index) {
                final o = list[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      if (o.metodePembayaran != null)
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              o.metodePembayaran!.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("#ORD${o.orderId}",
                                style: const TextStyle(
                                    fontSize: 13, color: Colors.grey)),

                            const SizedBox(height: 4),

                            Text(
                              o.nama,
                              style: AppTextStyles.homeGreeting.copyWith(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),

                            const SizedBox(height: 10),

                            Text("Produk: ${o.produk}"),
                            Text("Jumlah: ${o.jumlah}"),
                            Text("Alamat: ${o.alamat}"),

                            const SizedBox(height: 8),

                            Text("Status: ${o.statusPengiriman}"),

                            const SizedBox(height: 14),

                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => OrderDetailPage(
                                        orderId: o.orderId,
                                      ),
                                    ),
                                  );
                                  loadData();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color(0xFF7BC148),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text("Lihat Detail Tugas"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}

