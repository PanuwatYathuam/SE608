import 'package:flutter/material.dart';

import 'pages/home_page.dart';
import 'pages/actions_page.dart';
import 'pages/communication_page.dart';
import 'pages/containment_page.dart';
import 'pages/navigation_page.dart';
import 'pages/selection_page.dart';
import 'pages/input_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material Widgets Demo',
      routes: {
        '/actions': (_) => const ActionsPage(),
        '/communication': (_) => const CommunicationPage(),
        '/containment': (_) => const ContainmentPage(),
        '/navigation': (_) => const NavigationPage(),
        '/selection': (_) => const SelectionPage(),
        '/input': (_) => const InputPage(),
      },
      home: const HomePage(),
    );
  }
}
