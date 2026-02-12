import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = [
      ['Actions', '/actions'],
      ['Communication', '/communication'],
      ['Containment', '/containment'],
      ['Navigation', '/navigation'],
      ['Selection', '/selection'],
      ['Text Input', '/input'],
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Material Components")),
      body: ListView(
        children: pages.map((p) {
          return ListTile(
            title: Text(p[0]),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () => Navigator.pushNamed(context, p[1]),
          );
        }).toList(),
      ),
    );
  }
}
