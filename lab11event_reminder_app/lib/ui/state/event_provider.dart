import 'package:flutter/material.dart';
import '../../data/db/database_helper.dart';

class EventProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _events = [];
  List<Map<String, dynamic>> _categories = [];
  List<Map<String, dynamic>> get events => _events;
  List<Map<String, dynamic>> get categories => _categories;

  Future<void> loadAllData() async {
    final db = await DatabaseHelper.instance.database;
    _categories = await db.query('categories');
    // JOIN Table เพื่อเอาสีและชื่อหมวดหมู่มาใช้ในหน้า List
    _events = await db.rawQuery('''
      SELECT events.*, categories.name as catName, categories.color_hex as catColor 
      FROM events 
      LEFT JOIN categories ON events.category_id = categories.id
      ORDER BY event_date ASC, start_time ASC
    ''');
    notifyListeners();
  }

  Future<void> seedInitialCategories() async {
    final db = await DatabaseHelper.instance.database;
    final check = await db.query('categories');
    if (check.isEmpty) {
      final cats = [
        {'name': 'ประชุม', 'color_hex': '#F44336', 'icon_key': 'groups'},
        {'name': 'งานเอกสาร', 'color_hex': '#2196F3', 'icon_key': 'description'},
        {'name': 'อบรม', 'color_hex': '#4CAF50', 'icon_key': 'school'},
        {'name': 'ภารกิจภายนอก', 'color_hex': '#FF9800', 'icon_key': 'commute'},
        {'name': 'ส่วนตัว', 'color_hex': '#9C27B0', 'icon_key': 'person'},
      ];
      for (var c in cats) await db.insert('categories', c);
      await loadAllData();
    }
  }

  Future<void> addEvent(Map<String, dynamic> data) async {
    final db = await DatabaseHelper.instance.database;
    await db.insert('events', data);
    await loadAllData();
  }

  Future<void> deleteEvent(int id) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete('events', where: 'id = ?', whereArgs: [id]);
    await loadAllData();
  }
}