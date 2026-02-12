import 'package:flutter/material.dart';

class ActionsPage extends StatelessWidget {
  const ActionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Actions")),
      body: Center(
        child: ElevatedButton(onPressed: () {}, child: const Text("Press")),
      ),
    );
  }
}
