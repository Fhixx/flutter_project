import 'package:flutter/material.dart';
import '../../../core/styles/app_text_styles.dart';
import '../../../core/theme/app_colors.dart';
import '../services/order_service.dart';
import '../models/product_model.dart';
import '../../../core/session/user_session.dart';
import 'success_page.dart';

class PaymentPage extends StatelessWidget {
  final Product product;
  final int qty;
  final int total;
  final String address;
  final String note;

  const PaymentPage({
    super.key,
    required this.product,
    required this.qty,
    required this.total,
    required this.address,
    required this.note,
  });


  Future<void> confirm(BuildContext context) async {
    try {
      final res = await OrderService.createOrder(
        userId: UserSession.id!,
        productId: product.id,
        qty: qty,
        address: address,
        paymentMethod: "QRIS",
        note: note,
      );

      if (res["status"] == "success") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const SuccessPage()),
        );
      } else {
        throw Exception("Gagal simpan order");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundTop,
      body: Stack(
        children: [
          /// HEADER
          Container(
            height: 90,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
              ),
            ),
            child: const SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Text(
                      "Pembayaran",
                      style: AppTextStyles.homeTitle,
                    )
                  ],
                ),
              ),
            ),
          ),

          /// CONTENT
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                /// DETAIL
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: _card(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Detail Pembayaran",
                          style: AppTextStyles.sectionTitle),
                      const SizedBox(height: 16),

                      _row("Produk", product.label),
                      _row("Jumlah", "$qty"),
                      _row("Metode", "QRIS"),

                      const SizedBox(height: 10),
                      const Divider(),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total", style: AppTextStyles.formLabel),
                          Text(
                            "Rp $total",
                            style: AppTextStyles.sectionTitle.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                /// QRIS
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: _card(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Scan QRIS",
                        style: AppTextStyles.sectionTitle,
                      ),
                      const SizedBox(height: 16),

                      /// SIMULASI QR
                      Container(
                        height: 160,
                        width: 160,
                        decoration: BoxDecoration(
                          color: AppColors.border,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.qr_code,
                            size: 80,
                            color: Colors.black54,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        "Silakan scan QR untuk melakukan pembayaran",
                        textAlign: TextAlign.center,
                        style: AppTextStyles.subtitle,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                /// BUTTON KONFIRMASI
                GestureDetector(
                  onTap: () => confirm(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryDark],
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Center(
                      child: Text(
                        "Saya Sudah Bayar",
                        style: AppTextStyles.button,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ROW HELPER
  Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTextStyles.label),
          Text(value, style: AppTextStyles.subtitle),
        ],
      ),
    );
  }

  /// CARD STYLE
  static BoxDecoration _card() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      );
}