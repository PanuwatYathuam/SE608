import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/db/database_helper.dart';
import '../data/models/asset_model.dart';

class AssetProvider extends ChangeNotifier {
  List<Asset> _assets = [];
  List<Asset> get assets => _assets;

  // ดึงข้อมูลวัสดุทั้งหมดจาก DB
  Future<void> fetchAssets() async {
    final db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> maps = await db.query('assets');
    _assets = maps.map((item) => Asset.fromMap(item)).toList();
    notifyListeners();
  }

  // ฟังก์ชันยืมของ (บันทึกทั้งจำนวนคงเหลือและประวัติการยืม)
  Future<void> borrowAsset(int id, int amount, String username) async {
    final db = await DatabaseHelper.instance.database;
  
    // 1. ลดจำนวนคงเหลือในตาราง assets
    await db.rawUpdate('UPDATE assets SET remain = remain - ? WHERE id = ?', [amount, id]);

    // 2. บันทึกประวัติการยืมลงตาราง borrow_records
    await db.insert('borrow_records', {
      'asset_id': id,
      'username': username,
      'amount': amount,
      'status': 'borrowing',
      'borrow_date': DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now()),
    });
  
    await fetchAssets();
  }

  // ดึงรายการค้างส่ง (Join กับตาราง assets เพื่อเอาชื่อของมาโชว์)
  Future<List<Map<String, dynamic>>> getPendingBorrows(String? username) async {
    final db = await DatabaseHelper.instance.database;
    if (username == null) {
      // แอดมินดูทั้งหมด (เพื่อเลือกคืนให้รายคน)
      return await db.rawQuery('''
        SELECT b.*, a.name as asset_name FROM borrow_records b 
        JOIN assets a ON b.asset_id = a.id 
        WHERE b.status = 'borrowing'
      ''');
    } else {
      // ลูกบ้านดูเฉพาะของตัวเอง
      return await db.rawQuery('''
        SELECT b.*, a.name as asset_name FROM borrow_records b 
        JOIN assets a ON b.asset_id = a.id 
        WHERE b.username = ? AND b.status = 'borrowing'
      ''', [username]);
    }
  }

  // *** ส่วนที่เพิ่ม/แก้ไข: ฟังก์ชันรับคืนของรายบุคคล ***
  Future<void> returnFromRecord(int recordId, int assetId, int returnAmount, int originalBorrowedAmount) async {
    final db = await DatabaseHelper.instance.database;

    // 1. บวกจำนวนกลับเข้าไปในคลัง (ตาราง assets)
    await db.rawUpdate(
      'UPDATE assets SET remain = remain + ? WHERE id = ?',
      [returnAmount, assetId]
    );

    // 2. อัปเดตสถานะในประวัติการยืม (ตาราง borrow_records)
    if (returnAmount >= originalBorrowedAmount) {
      // ถ้าคืนครบ ให้เปลี่ยนสถานะเป็น returned เพื่อให้หายไปจากหน้า "ค้างส่ง"
      await db.update(
        'borrow_records',
        {'status': 'returned', 'returned_amount': originalBorrowedAmount},
        where: 'id = ?',
        whereArgs: [recordId],
      );
    } else {
      // ถ้าคืนบางส่วน ให้ลบจำนวนที่ค้างไว้ออก และเพิ่มยอดที่คืนแล้ว
      await db.rawUpdate(
        'UPDATE borrow_records SET amount = amount - ?, returned_amount = returned_amount + ? WHERE id = ?',
        [returnAmount, returnAmount, recordId]
      );
    }

    await fetchAssets(); // รีเฟรชหน้าจอหลัก
  }

  // หมายเหตุ: ฟังก์ชัน returnAsset เดิมสามารถลบออกได้เลย 
  // เพราะเราจะเปลี่ยนไปใช้ returnFromRecord แทนเพื่อให้แอดมินเลือกคนคืนได้
}