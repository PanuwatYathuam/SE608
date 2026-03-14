import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('community_system.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    // 1. ตารางผู้ใช้งาน (Users)
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        password TEXT NOT NULL,
        role TEXT NOT NULL,
        display_name TEXT NOT NULL
      )
    ''');

    // 2. ตารางวัสดุอุปกรณ์ (Assets)
    await db.execute('''
      CREATE TABLE assets (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        category TEXT NOT NULL,
        stock INTEGER DEFAULT 0,
        remain INTEGER DEFAULT 0,
        borrower TEXT,
        last_date TEXT
      )
    ''');

    // 3. เพิ่มตารางประวัติการยืม (Borrow Records)
    await db.execute('''
      CREATE TABLE borrow_records (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        asset_id INTEGER,
        username TEXT,
        amount INTEGER,
        returned_amount INTEGER DEFAULT 0,
        status TEXT, -- 'borrowing' หรือ 'returned'
        borrow_date TEXT
      )
    ''');

    // --- ใส่ข้อมูลเริ่มต้น (Seed Data) ---
    
    // ข้อมูล User ตามที่คุณต้องการ
    await db.insert('users', {
      'username': 'admin_kamnan', 
      'password': '9999', 
      'role': 'admin', 
      'display_name': 'กำนัน (กรรมการ)'
    });
    await db.insert('users', {
      'username': 'somchai_jaide', 
      'password': '1234', 
      'role': 'user', 
      'display_name': 'คุณสมชาย (ลูกบ้าน)'
    });
    await db.insert('users', {
      'username': 'mana_reakdee', 
      'password': '1234', 
      'role': 'user', 
      'display_name': 'คุณมานะ (ลูกบ้าน)'
    });

    // ข้อมูลวัสดุ 9 อย่าง (ย่อให้ดูเป็นตัวอย่าง)
    final items = [
      {'name': 'เต็นท์ 6 ขา', 'category': 'ทั่วไป', 'stock': 5, 'remain': 5},
      {'name': 'หม้อแกง', 'category': 'เครื่องครัว', 'stock': 10, 'remain': 10},
      {'name': 'เครื่องเสียง', 'category': 'ไฟฟ้า', 'stock': 2, 'remain': 2},
    ];
    for (var item in items) { await db.insert('assets', item); }
  }

  // ฟังก์ชันเช็ค Login
  Future<Map<String, dynamic>?> login(String user, String pass) async {
    final db = await instance.database;
    final res = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [user, pass],
    );
    return res.isNotEmpty ? res.first : null;
  }
}