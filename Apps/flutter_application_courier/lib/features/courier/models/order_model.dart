class OrderModel {
  final int orderId;
  final String nama;
  final String produk;
  final int jumlah;
  final String alamat;
  final String? metodePembayaran;
  final String? statusPengiriman;

  OrderModel({
    required this.orderId,
    required this.nama,
    required this.produk,
    required this.jumlah,
    required this.alamat,
    this.metodePembayaran,
    this.statusPengiriman,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json['order_id'],
      nama: json['nama'],
      produk: json['produk'],
      jumlah: json['jumlah'],
      alamat: json['alamat'],
      metodePembayaran: json['metode_pembayaran'],
      statusPengiriman: json['status_pengiriman'],
    );
  }
}