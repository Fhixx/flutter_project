class OrderModel {
  final int orderId;
  final String nama;
  final String produk;
  final int jumlah;
  final String alamat;

  OrderModel({
    required this.orderId,
    required this.nama,
    required this.produk,
    required this.jumlah,
    required this.alamat,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json['order_id'],
      nama: json['nama'],
      produk: json['produk'],
      jumlah: json['jumlah'],
      alamat: json['alamat'],
    );
  }
}