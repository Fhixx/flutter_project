import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../widgets/header_manager.dart';
import '../widgets/stat_card.dart';
import '../widgets/menu_card.dart';
import '../widgets/home_header.dart';

import '../../addstock/pages/add_stock_page.dart';
import '../../verification/pages/verification_page.dart';
import '../../delivery/pages/input_courier_page.dart';
import '../../finance/pages/finance_page.dart';

class ManagerDashboardPage extends StatefulWidget {
  const ManagerDashboardPage({super.key});

  @override
  State<ManagerDashboardPage> createState() => _ManagerDashboardPageState();
}

class _ManagerDashboardPageState extends State<ManagerDashboardPage> {
  int stokA = 0;
  int stokB = 0;
  int pesananMasuk = 0;
  int ditolak = 0;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDashboard();
  }

  Future<void> fetchDashboard() async {
    try {
      final response = await http.get(
        Uri.parse("https://flutterproject-production.up.railway.app/dashboard/"),
      );

      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        print("DATA: $data");

        setState(() {
          stokA = data["stokA"] ?? 0;
          stokB = data["stokB"] ?? 0;
          pesananMasuk = data["pesananMasuk"] ?? 0;
          ditolak = data["ditolak"] ?? 0;
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F8FC),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: fetchDashboard, // fungsi refresh
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      const HomeHeader(),
                      const SizedBox(height: 8),
                      const HeaderManager(),

                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            /// STATISTIK
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Statistik Hari Ini",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            const SizedBox(height: 12),

                            GridView.count(
                              crossAxisCount: 2,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              children: [
                                StatCard(
                                  title: "Stok A",
                                  value: stokA.toString(),
                                  color: const Color(0xFF7BC148),
                                ),
                                StatCard(
                                  title: "Stok B",
                                  value: stokB.toString(),
                                  color: const Color(0xFF7BC148),
                                ),
                                StatCard(
                                  title: "Pesanan Masuk",
                                  value: pesananMasuk.toString(),
                                  color: const Color(0xFFEED982),
                                ),
                                StatCard(
                                  title: "Ditolak",
                                  value: ditolak.toString(),
                                  color: const Color(0xFFFF6B6B),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            /// MENU
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Menu Utama",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),

                            const SizedBox(height: 12),

                            MenuCard(
                              title: "Pengadaan Barang",
                              color: const Color(0xFF7BC148),
                              icon: Icons.inventory_2,
                              onTap: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const AddStockPage(),
                                  ),
                                );

                                if (result == true) {
                                  print("REFRESH");
                                  await fetchDashboard();
                                }
                              },
                            ),
                            const SizedBox(height: 12),

                            MenuCard(
                              title: "Monitoring Pesanan",
                              color: const Color(0xFFEED982),
                              icon: Icons.bar_chart,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const VerificationPage(),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 12),

                            MenuCard(
                              title: "Penugasan Karyawan",
                              color: const Color(0xFF64B5F6),
                              icon: Icons.people,
                              onTap: () {
                                 Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => DeliveryPage(),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 12),

                            MenuCard(
                              title: "Monitoring Keuangan",
                              color: const Color(0xFFBA68C8),
                              icon: Icons.store,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => FinancePage(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
