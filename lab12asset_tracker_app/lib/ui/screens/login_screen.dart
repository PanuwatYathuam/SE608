import 'package:flutter/material.dart';
import '../../data/db/database_helper.dart';
import 'home_screen.dart'; // เดี๋ยวเราจะสร้างไฟล์นี้ในขั้นต่อไป

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userController = TextEditingController();
  final _passController = TextEditingController();
  bool _isLoading = false;

  void _handleLogin() async {
    setState(() => _isLoading = true);
    
    final user = await DatabaseHelper.instance.login(
      _userController.text, 
      _passController.text
    );

    setState(() => _isLoading = false);

    if (user != null) {
      // ถ้า Login สำเร็จ ส่งค่า Role และ Name ไปหน้า Home
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (_) => HomeScreen(
          userRole: user['role'], 
          userName: user['display_name']
        )
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              const Icon(Icons.account_balance, size: 100, color: Colors.teal),
              const SizedBox(height: 20),
              const Text("ระบบยืมวัสดุอุปกรณ์หมู่บ้าน", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 40),
              TextField(
                controller: _userController,
                decoration: const InputDecoration(labelText: "Username", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Password", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 30),
              _isLoading 
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                    onPressed: _handleLogin, 
                    child: const Text("เข้าสู่ระบบ"),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}