import 'package:flutter/material.dart';

class InputPage extends StatelessWidget {
  const InputPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Text Input")),
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: TextField(decoration: InputDecoration(labelText: "Enter name")),
      ),
    );
  }
}
