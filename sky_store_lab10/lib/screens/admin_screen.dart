import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login_screen.dart';

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  List users = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final response = await http.get(Uri.parse('https://fakestoreapi.com/users'));
    if (response.statusCode == 200) {
      setState(() {
        users = json.decode(response.body);
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Panel (User Management)"),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(icon: Icon(Icons.logout), onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen())))
        ],
      ),
      body: isLoading 
        ? Center(child: CircularProgressIndicator()) 
        : ListView.builder(
            itemCount: users.length,
            itemBuilder: (ctx, i) => Card(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListTile(
                leading: CircleAvatar(child: Text("${users[i]['id']}")),
                title: Text("${users[i]['name']['firstname']} ${users[i]['name']['lastname']}"),
                subtitle: Text("Username: ${users[i]['username']} \nEmail: ${users[i]['email']}"),
                isThreeLine: true,
              ),
            ),
          ),
    );
  }
}