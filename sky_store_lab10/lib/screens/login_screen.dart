import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'product_list_screen.dart';
import 'admin_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userController = TextEditingController();
  final _passController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() => _isLoading = true);
    if (_userController.text == "johnd" && _passController.text == "m38rmn=") {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => AdminScreen()));
      setState(() => _isLoading = false);
      return; // จบการทำงานตรงนี้เลย ไม่ต้องรอ API
    }
    // ตรวจสอบ Username / Password จาก API
    final res = await http.get(Uri.parse('https://fakestoreapi.com/users'));
    if (res.statusCode == 200) {
      List users = json.decode(res.body);
      // หา user ที่ตรงกับที่กรอก
      var user = users.firstWhere(
        (u) => u['username'] == _userController.text && u['password'] == _passController.text,
        orElse: () => null,
      );

      if (user != null) {
        // เงื่อนไข: ถ้าเป็น johnd ให้ไปหน้า Admin (ID = 1 ตามที่เพื่อนเขียน)
        if (user['username'] == 'johnd') {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => AdminScreen()));
        } else {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ProductListScreen()));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง")));
      }
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(30),
          child: Column(
            children: [
              Icon(Icons.lock_outline, size: 80, color: Colors.deepPurple),
              SizedBox(height: 20),
              Text("Sky Store Login", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 30),
              TextField(controller: _userController, decoration: InputDecoration(labelText: "Username (เช่น johnd)", border: OutlineInputBorder())),
              SizedBox(height: 15),
              TextField(controller: _passController, obscureText: true, decoration: InputDecoration(labelText: "Password (เช่น m38rmn=)", border: OutlineInputBorder())),
              SizedBox(height: 25),
              _isLoading 
                ? CircularProgressIndicator() 
                : SizedBox(width: double.infinity, height: 50, child: ElevatedButton(onPressed: _login, child: Text("LOGIN")))
            ],
          ),
        ),
      ),
    );
  }
}