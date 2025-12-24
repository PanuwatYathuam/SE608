void main() {
  print('--- เริ่มต้นโปรแกรม ---');

  Product p1 = Product(id: 'P001', name: 'Notebook', price: 50.0, stock: 50);
  print('New Product created: ${p1.id} (${p1.name})');

  DigitalProduct d1 = DigitalProduct(
    id: 'D001',
    name: 'E-Book Flutter',
    price: 199.0,
    fileSizeMB: 120.5,
  );
  print('New Product created: ${d1.id} (${d1.name})');

  FoodProduct f1 = FoodProduct(
    id: 'F001',
    name: 'Milk',
    price: 25.0,
    stock: 15,
    expireDate: '2026-01-10',
  );
  print('New Product created: ${f1.id} (${f1.name})');

  print('\n--- ทดสอบ Setter Price (ป้องกันค่าติดลบ) ---');
  p1.price = -500;

  print('\n--- ทดสอบ Method ต่างๆ ---');
  print('ลดราคา Notebook 10%');
  p1.applyDiscount(10);

  print('เพิ่มสต็อก Milk +50');
  f1.restock(50);

  print('\n------------------------------------------------');
  print('--- แสดงผลข้อมูลสินค้าทั้งหมด (Polymorphism) ---');
  print('------------------------------------------------');

  List<Product> productList = [p1, d1, f1];

  for (var item in productList) {
    item.showInfo();
    print('----------------');
  }
}

class Product {
  String _id;
  String name;
  double _price;
  int? stock;

  Product({
    required String id,
    required this.name,
    required double price,
    this.stock,
  }) : _id = id,
       _price = price;

  String get id => _id;

  double get price => _price;

  set price(double newPrice) {
    if (newPrice > 0) {
      _price = newPrice;
    } else {
      print('ราคาไม่ถูกต้อง (ต้อง > 0) -> ไม่เปลี่ยนค่า'); // 
    }
  }

  void applyDiscount(double percent) {
    if (percent >= 0 && percent <= 100) {
      _price = _price - (_price * (percent / 100));
    } else {
      print('เปอร์เซ็นต์ส่วนลดไม่ถูกต้อง');
    }
  }

  void restock(int amount) {

    stock = (stock ?? 0) + amount; // 
  }

  void showInfo() {
    print('ID: $_id');
    print('Name: $name');
    print('Price: $_price');

    print('Stock: ${stock ?? "ยังไม่ระบุสต็อก"}');
  }
}

class DigitalProduct extends Product {
  double fileSizeMB;

  DigitalProduct({
    required String id,
    required String name,
    required double price,
    int? stock,
    required this.fileSizeMB,
  }) : super(id: id, name: name, price: price, stock: stock);

  @override
  void showInfo() {
    super.showInfo();
    print('Type: Digital');
    print('File Size: $fileSizeMB MB');
  }
}

class FoodProduct extends Product {
  String expireDate;

  FoodProduct({
    required String id,
    required String name,
    required double price,
    int? stock,
    required this.expireDate,
  }) : super(id: id, name: name, price: price, stock: stock);

  @override
  void showInfo() {
    super.showInfo();
    print('Type: Food');
    print('Expire Date: $expireDate');
  }
}