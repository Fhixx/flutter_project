import 'package:flutter/material.dart';
import '../widgets/order_form_card.dart';


class CreateOrderPage extends StatelessWidget {
  const CreateOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Header(), // ← BENAR DI SINI
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: const OrderFormCard(),
            ),
          ),
        ],
      ),
    );
  }
}

