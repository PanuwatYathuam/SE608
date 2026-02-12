import 'package:flutter/material.dart';

class SelectionPage extends StatefulWidget {
  const SelectionPage({super.key});

  @override
  State<SelectionPage> createState() => _SelectionPageState();
}

class _SelectionPageState extends State<SelectionPage> {
  bool checked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Selection")),
      body: Center(
        child: Checkbox(
          value: checked,
          onChanged: (v) {
            setState(() {
              checked = v!;
            });
          },
        ),
      ),
    );
  }
}
