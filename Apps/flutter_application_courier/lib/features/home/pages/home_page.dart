import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/home_header.dart';
import '../widgets/home_greeting_card.dart';
import '../sevices/delivery_service.dart';
import '../../courier/pages/courier_order_page.dart';

class HomePage extends StatefulWidget {
  final String nama;
  final String id;

  const HomePage({super.key, required this.nama, required this.id});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int tugas = 0;
  int proses = 0;
  int selesai = 0;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchStatistik();
  }

  Future<void> fetchStatistik() async {
    try {
      final res = await DeliveryService.getStatistik(widget.id);

      if (res["success"]) {
        setState(() {
          tugas = res["data"]["tugas"] ?? 0;
          proses = res["data"]["proses"] ?? 0;
          selesai = res["data"]["selesai"] ?? 0;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundTop,
      body: Column(
        children: [
          const HomeHeader(),
          const SizedBox(height: 24),

          HomeGreetingCard(nama: widget.nama),

          const SizedBox(height: 24),

          /// STATISTIK
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: isLoading
                ? const CircularProgressIndicator()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _statCard("Tugas", tugas, AppColors.primary),
                      _statCard("Proses", proses, AppColors.primaryDark),
                      _statCard("Selesai", selesai, Colors.green),
                    ],
                  ),
          ),

          const SizedBox(height: 32),

          /// BUTTON
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CourierOrdersPage(
                        courierId: int.parse(widget.id), 
                      ),
                    ),
                  );
                },
                child: const Text("Lihat Daftar Tugas"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(String title, int value, Color color) {
    return Container(
      width: 100,
      height: 120,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(blurRadius: 6, color: Colors.black12)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title),
          const SizedBox(height: 10),
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
