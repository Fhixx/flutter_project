class CourierModel {
  final int id;
  final String nama;

  CourierModel({
    required this.id,
    required this.nama,
  });

  factory CourierModel.fromJson(Map<String, dynamic> json) {
    return CourierModel(
      id: json['id'],
      nama: json['nama'],
    );
  }
}