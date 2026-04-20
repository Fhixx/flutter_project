import 'package:flutter/material.dart';
import '../../../core/styles/app_text_styles.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';
import '../../../core/theme/app_colors.dart';
import '../services/order_service.dart';
import '../../../core/session/user_session.dart';
import '../pages/payment_page.dart';



class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      alignment: Alignment.center, 
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              const SizedBox(width: 8),
              const Text(
                "Form Pemesanan",
                style: AppTextStyles.homeTitle,
              )
            ],
          ),
        ),
      )
      
    );
  }
}

class OrderFormCard extends StatefulWidget {
  const OrderFormCard({super.key});

  @override
  State<OrderFormCard> createState() => _OrderFormCardState();
}


class _OrderFormCardState extends State<OrderFormCard> {
  List<Product> products = [];
  Product? selectedProduct;

  String? paymentMethod;
  final qtyController = TextEditingController();
  final addressController = TextEditingController();
  final noteController = TextEditingController();
  

  int totalPrice = 0;

  

  Future<void> submitOrder() async {
    if (selectedProduct == null ||
        qtyController.text.isEmpty ||
        addressController.text.isEmpty ||
        paymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lengkapi semua data")),
      );
      return;
    }

    final qty = int.tryParse(qtyController.text) ?? 0;


    if (paymentMethod == "QRIS") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PaymentPage(
            product: selectedProduct!,
            qty: qty,
            total: totalPrice,
            address: addressController.text,
            note: noteController.text,
          ),
        ),
      );
      return;
    }

    /// =========================
    /// 🟢 COD → LANGSUNG SIMPAN
    /// =========================
    try {
      final res = await OrderService.createOrder(
        userId: UserSession.id!,
        productId: selectedProduct!.id,
        qty: qty,
        address: addressController.text,
        paymentMethod: "COD",
        note: noteController.text,
      );

      if (res["status"] == "success") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Pesanan COD berhasil dibuat")),
        );
        Navigator.pop(context);
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
  void initState() {
    super.initState();
    loadProducts();
    qtyController.addListener(calcTotal);
  }

  Future<void> loadProducts() async {
    final data = await ProductService.fetchProducts();
    setState(() => products = data);
  }

  void calcTotal() {
    if (selectedProduct == null) return;

    final qty = int.tryParse(qtyController.text) ?? 0;
    setState(() {
      totalPrice = selectedProduct!.price * qty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardStyle(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Detail Pesanan", style: AppTextStyles.sectionTitle),
          const SizedBox(height: 20),

          /// PRODUK
          Text("Produk", style: AppTextStyles.formLabel),
          const SizedBox(height: 6),
          DropdownButtonFormField<Product>(
            value: selectedProduct,
            items: products
                .map((p) => DropdownMenuItem(
                      value: p,
                      child: Text(p.label),
                    ))
                .toList(),
            onChanged: (v) {
              setState(() => selectedProduct = v);
              calcTotal();
            },
            decoration: _inputDecoration(),
          ),

          const SizedBox(height: 16),

          /// JUMLAH
          Text("Jumlah", style: AppTextStyles.formLabel),
          const SizedBox(height: 6),
          TextField(
            controller: qtyController,
            keyboardType: TextInputType.number,
            decoration: _inputDecoration(hint: "Masukkan jumlah"),
          ),

          const SizedBox(height: 16),

          /// TOTAL OTOMATIS
          Text("Total Harga", style: AppTextStyles.formLabel),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFF7F7F7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              "Rp $totalPrice",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),


          const SizedBox(height: 16),

          /// ALAMAT
          Text("Alamat Pengiriman", style: AppTextStyles.formLabel),
          const SizedBox(height: 6),
          TextField(
            controller: addressController,
            maxLines: 2,
            decoration: _inputDecoration(hint: "Masukkan alamat"),
          ),

          const SizedBox(height: 16),

          /// PEMBAYARAN
          Text("Metode Pembayaran", style: AppTextStyles.formLabel),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            value: paymentMethod,
            items: ["COD", "QRIS"]
                .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                .toList(),
            onChanged: (v) => setState(() => paymentMethod = v),
            decoration: _inputDecoration(),
          ),


          const SizedBox(height: 16),

          /// CATATAN
          Text("Catatan", style: AppTextStyles.formLabel),
          const SizedBox(height: 6),
          TextField(
            controller: noteController,
            maxLines: 2,
            decoration: _inputDecoration(hint: "Masukkan catatan tambahan"),
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: submitOrder,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Buat Pesanan",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          
        ],
      ),
    );
  }

  BoxDecoration _cardStyle() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 6,
            offset: Offset(0, 4),
          )
        ],
      );

  InputDecoration _inputDecoration({String? hint}) => InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF7F7F7),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      );
}
