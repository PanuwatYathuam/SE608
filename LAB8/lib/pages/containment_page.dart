import 'package:flutter/material.dart';

class ContainmentPage extends StatelessWidget {
  const ContainmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Containment")),
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: Card(child: ListTile(title: Text("Flutter Card"))),
      ),
    );
  }
}
