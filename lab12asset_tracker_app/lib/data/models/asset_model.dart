class Asset {
  final int? id;
  final String name;
  final String category;
  int stock;
  int remain;
  String? borrower;
  String? lastDate;

  Asset({
    this.id,
    required this.name,
    required this.category,
    this.stock = 0,
    this.remain = 0,
    this.borrower,
    this.lastDate,
  });

  // แปลงจาก Map (ใน DB) มาเป็น Object ใน Flutter
  factory Asset.fromMap(Map<String, dynamic> map) => Asset(
    id: map['id'],
    name: map['name'],
    category: map['category'],
    stock: map['stock'] ?? 0,
    remain: map['remain'] ?? 0,
    borrower: map['borrower'],
    lastDate: map['last_date'],
  );
}