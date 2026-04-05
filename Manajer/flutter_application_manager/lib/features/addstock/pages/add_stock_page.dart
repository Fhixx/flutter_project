import 'package:flutter/material.dart';
import '../../addstock/services/stock_service.dart';
import '../../../core/styles/app_text_styles.dart';
import '../../../core/theme/app_colors.dart';

class AddStockPage extends StatefulWidget {
  const AddStockPage({super.key});

  @override
  State<AddStockPage> createState() => _AddStockPageState();
}

class _AddStockPageState extends State<AddStockPage> {
  final qtyController = TextEditingController();
  final ketController = TextEditingController();

  int productId = 1;
  String tipe = "masuk";

  bool isLoading = false;

  InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFFF7F9FC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  void submit() async {
    if (qtyController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Jumlah tidak boleh kosong")),
      );
      return;
    }

    int qty;

    try {
      qty = int.parse(qtyController.text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Jumlah harus berupa angka")),
      );
      return;
    }

    setState(() => isLoading = true);

    final success = await StockService.addStock(
      productId: productId,
      qty: qty,
      tipe: tipe,
      keterangan: ketController.text,
    );

    setState(() => isLoading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Stok berhasil ditambahkan")),
      );
      Navigator.pop(context, true); // kirim signal refresh
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Gagal menambahkan stok")));
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
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
              
            ),
            child: Row(
              children: [
                /// BACK BUTTON
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                ),

                const SizedBox(width: 8),

                /// TITLE
                const Text(
                  "Tambah Stok",
                  style: AppTextStyles.header,
                ),
              ],
            ),
          ),

          /// 🔥 CONTENT
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 6),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// TITLE
                    Text("Form Tambah Stok", style: AppTextStyles.title),

                    const SizedBox(height: 20),

                    /// PRODUK
                    Text("Produk", style: AppTextStyles.label),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<int>(
                      value: productId,
                      items: const [
                        DropdownMenuItem(value: 1, child: Text("Produk A")),
                        DropdownMenuItem(value: 2, child: Text("Produk B")),
                      ],
                      onChanged: (value) {
                        setState(() => productId = value!);
                      },
                      decoration: _inputDecoration(),
                    ),

                    const SizedBox(height: 16),

                    /// TIPE
                    Text("Tipe", style: AppTextStyles.label),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      value: tipe,
                      items: const [
                        DropdownMenuItem(value: "masuk", child: Text("Stok Masuk")),
                        DropdownMenuItem(value: "keluar", child: Text("Stok Keluar")),
                      ],
                      onChanged: (value) {
                        setState(() => tipe = value!);
                      },
                      decoration: _inputDecoration(),
                    ),

                    const SizedBox(height: 16),

                    /// JUMLAH
                    Text("Jumlah", style: AppTextStyles.label),
                    const SizedBox(height: 6),
                    TextField(
                      controller: qtyController,
                      keyboardType: TextInputType.number,
                      decoration: _inputDecoration().copyWith(
                        hintText: "Masukkan jumlah stok",
                        prefixIcon: const Icon(Icons.inventory_2),
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// KETERANGAN
                    Text("Keterangan", style: AppTextStyles.label),
                    const SizedBox(height: 6),
                    TextField(
                      controller: ketController,
                      decoration: _inputDecoration().copyWith(
                        hintText: "Opsional",
                        prefixIcon: const Icon(Icons.note_alt),
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// BUTTON
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text("Simpan",
                            style: TextStyle(
                              color: Colors.white
                            ),),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
}
