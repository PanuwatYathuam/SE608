import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ui/state/event_provider.dart';
import 'ui/screens/home_screen.dart';

void main() async {
  // ต้องมีบรรทัดนี้เพื่อให้ SQLite ทำงานได้ก่อน runApp
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EventProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Event Reminder Lab 11',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}