import 'package:flutter/material.dart';
import '../widgets/home_header.dart';
import '../widgets/home_greeting_card.dart';
import '../widgets/home_menu_card.dart';
import '../../order/pages/create_order_page.dart';
import '../../status/status_page.dart';



class HomePage extends StatelessWidget {
  final String username;
  final int userId;

  const HomePage({
    super.key,
    required this.username,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F8FC),
      body: Column(
        children: [
          const HomeHeader(),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  HomeGreetingCard(username: username),
                  const SizedBox(height: 24),

                  HomeMenuCard(
                    title: "Buat Pesanan Baru",
                    icon: Icons.add_shopping_cart,
                    color: const Color(0xFF7BC148),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CreateOrderPage(),
                        ),
                      );
                    },
                  ),


                  const SizedBox(height: 16),

                  HomeMenuCard(
                    title: "Status Pesanan",
                    icon: Icons.receipt_long,
                    color: const Color(0xFFE5C34A),
                    onTap: () {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (_) => OrderStatusPage(
                            userId : userId,
                          ),
                          ),
                        );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
