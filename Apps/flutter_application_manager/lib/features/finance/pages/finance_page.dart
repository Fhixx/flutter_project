import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/styles/app_text_styles.dart';

class FinancePage extends StatefulWidget {
  const FinancePage({super.key});

  @override
  State<FinancePage> createState() => _FinancePageState();
}

class _FinancePageState extends State<FinancePage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  int pemasukan = 0;
  int pengeluaran = 0;
  int saldo = 0;
  List transaksi = [];

  bool isLoading = true;
  String filter = "all";

  final formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() => isLoading = true);

    final res = await http.get(
      Uri.parse("http://10.0.2.2:8000/finance-report/?filter=$filter"),
    );

    final data = jsonDecode(res.body);

    setState(() {
      pemasukan = data["pemasukan"];
      pengeluaran = data["pengeluaran"];
      saldo = data["saldo"];
      transaksi = data["transaksi"];
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F8FC),

      /// HEADER
      appBar: AppBar(
        title: const Text(
          "Laporan Keuangan",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const SizedBox(height: 12),

                /// TAB BAR CARD
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
                      indicator: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.black54,
                      indicatorSize: TabBarIndicatorSize.tab,
                      onTap: (index) {
                        if (index == 0) filter = "all";
                        if (index == 1) filter = "minggu";
                        if (index == 2) filter = "bulan";
                        fetchData();
                      },
                      tabs: const [
                        Tab(text: "Semua"),
                        Tab(text: "Minggu"),
                        Tab(text: "Bulan"),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                /// 📊 GRAFIK BATANG
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    height: 200,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: BarChart(
                      BarChartData(
                        borderData: FlBorderData(show: false),

                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                        ),

                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                if (value == 0) return const Text("Masuk");
                                if (value == 1) return const Text("Keluar");
                                return const Text("");
                              },
                            ),
                          ),
                        ),

                        maxY:
                            (pemasukan > pengeluaran ? pemasukan : pengeluaran)
                                .toDouble() *
                            1.2, // 🔥 biar ada ruang atas

                        barGroups: [
                          BarChartGroupData(
                            x: 0,
                            barRods: [
                              BarChartRodData(
                                toY: pemasukan.toDouble(),
                                color: Colors.green,
                                width: 24,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ],
                          ),
                          BarChartGroupData(
                            x: 1,
                            barRods: [
                              BarChartRodData(
                                toY: pengeluaran.toDouble(),
                                color: Colors.red,
                                width: 24,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                /// 💰 SALDO
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Total Saldo", style: AppTextStyles.subtitle),
                      const SizedBox(height: 8),
                      Text(
                        formatter.format(saldo),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                /// CARD PEMASUKAN & PENGELUARAN
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _card("Pemasukan", pemasukan, Colors.green),
                    _card("Pengeluaran", pengeluaran, Colors.red),
                  ],
                ),

                const SizedBox(height: 16),

                /// LIST TRANSAKSI
                Expanded(
                  child: ListView.builder(
                    itemCount: transaksi.length,
                    itemBuilder: (context, index) {
                      final t = transaksi[index];

                      return ListTile(
                        leading: Icon(
                          t["tipe"] == "pemasukan"
                              ? Icons.arrow_downward
                              : Icons.arrow_upward,
                          color: t["tipe"] == "pemasukan"
                              ? Colors.green
                              : Colors.red,
                        ),
                        title: Text(t["keterangan"]),
                        subtitle: Text(t["tanggal"].toString()),
                        trailing: Text(
                          formatter.format(t["jumlah"]),
                          style: TextStyle(
                            color: t["tipe"] == "pemasukan"
                                ? Colors.green
                                : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _card(String title, int value, Color color) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(title),
          const SizedBox(height: 8),
          Text(
            formatter.format(value),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
