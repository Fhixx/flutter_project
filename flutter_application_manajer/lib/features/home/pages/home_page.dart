import 'package:flutter/material.dart';
import '../widgets/home_header.dart';
// import '../widgets/home_greeting_card.dart';
import '../widgets/home_menu_card.dart';



class HomePage extends StatelessWidget {
  // final String username;

  // const HomePage({
  //   super.key,
  //   required this.username,
  // });

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
                  // HomeGreetingCard(username: username),
                  // const SizedBox(height: 24),

                  HomeMenuCard(
                    title: "manajer",
                    icon: Icons.add_shopping_cart,
                    color: const Color(0xFF7BC148),
                    onTap: () {},
                  ),


                  const SizedBox(height: 16),

                  HomeMenuCard(
                    title: "manajer",
                    icon: Icons.receipt_long,
                    color: const Color(0xFFE5C34A),
                    onTap: () {},
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
