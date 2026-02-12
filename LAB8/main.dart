import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material 3 Demo',
      // เปิดใช้งาน Material 3 เพื่อดีไซน์ที่ทันสมัย
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
      ),
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

// --- Reusable Widget สำหรับแสดง Code ---
Widget codeBox(String code) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xFF282C34), // สีโทน Dark Mode
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Example Code", style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
        const Divider(color: Colors.white24),
        Text(
          code,
          style: const TextStyle(
            color: Color(0xFFABB2BF),
            fontFamily: 'monospace',
            fontSize: 13,
          ),
        ),
      ],
    ),
  );
}

// --- Layout พื้นฐานสำหรับหน้าย่อย ---
class DemoPageLayout extends StatelessWidget {
  final String title;
  final Widget demo;
  final String code;

  const DemoPageLayout({super.key, required this.title, required this.demo, required this.code});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Card(
              elevation: 0,
              color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Center(child: demo),
              ),
            ),
            const SizedBox(height: 24),
            codeBox(code),
          ],
        ),
      ),
    );
  }
}

/* ================= Home Page ================= */

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> pages = [
      {'title': 'Actions', 'route': '/actions', 'icon': Icons.touch_app, 'color': Colors.blue},
      {'title': 'Communication', 'route': '/communication', 'icon': Icons.chat_bubble, 'color': Colors.orange},
      {'title': 'Containment', 'route': '/containment', 'icon': Icons.inventory_2, 'color': Colors.green},
      {'title': 'Navigation', 'route': '/navigation', 'icon': Icons.explore, 'color': Colors.red},
      {'title': 'Selection', 'route': '/selection', 'icon': Icons.check_box, 'color': Colors.purple},
      {'title': 'Text Input', 'route': '/input', 'icon': Icons.edit_text, 'color': Colors.teal},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Material Components", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: pages.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final page = pages[index];
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              leading: CircleAvatar(
                backgroundColor: page['color'].withOpacity(0.2),
                child: Icon(page['icon'], color: page['color']),
              ),
              title: Text(page['title'], style: const TextStyle(fontWeight: FontWeight.w600)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.pushNamed(context, page['route']),
            ),
          );
        },
      ),
    );
  }
}

/* ================= Actions ================= */

class ActionsPage extends StatelessWidget {
  const ActionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const DemoPageLayout(
      title: "Actions",
      demo: FilledButton(onPressed: null, child: Text("Material 3 Button")),
      code: '''FilledButton(
  onPressed: () {},
  child: Text("Press Me"),
);''',
    );
  }
}

/* ================= Communication ================= */

class CommunicationPage extends StatelessWidget {
  const CommunicationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Communication")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.send),
              label: const Text("Show SnackBar"),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    behavior: SnackBarBehavior.floating,
                    content: const Text("Message Sent!"),
                    action: SnackBarAction(label: "Undo", onPressed: () {}),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            codeBox('''ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    behavior: SnackBarBehavior.floating,
    content: Text("Saved"),
  ),
);'''),
          ],
        ),
      ),
    );
  }
}

/* ================= Containment ================= */

class ContainmentPage extends StatelessWidget {
  const ContainmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const DemoPageLayout(
      title: "Containment",
      demo: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.album),
              title: Text('The Enchanted Nightingale'),
              subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
            ),
          ],
        ),
      ),
      code: '''Card(
  child: Column(
    children: [
      ListTile(title: Text("Title")),
    ],
  ),
);''',
    );
  }
}

/* ================= Navigation ================= */

class NavigationPage extends StatelessWidget {
  const NavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const DemoPageLayout(
      title: "Navigation",
      demo: Text("Use Navigator.push() to switch screens"),
      code: '''Navigator.pushNamed(
  context, 
  '/actions'
);''',
    );
  }
}

/* ================= Selection ================= */

class SelectionPage extends StatefulWidget {
  const SelectionPage({super.key});

  @override
  State<SelectionPage> createState() => _SelectionPageState();
}

class _SelectionPageState extends State<SelectionPage> {
  bool checked = false;
  double _currentSliderValue = 20;

  @override
  Widget build(BuildContext context) {
    return DemoPageLayout(
      title: "Selection",
      demo: Column(
        children: [
          SwitchListTile(
            title: const Text("Enable Notifications"),
            value: checked,
            onChanged: (v) => setState(() => checked = v),
          ),
          Slider(
            value: _currentSliderValue,
            max: 100,
            divisions: 5,
            label: _currentSliderValue.round().toString(),
            onChanged: (double value) => setState(() => _currentSliderValue = value),
          ),
        ],
      ),
      code: '''SwitchListTile(
  value: checked,
  onChanged: (v) => setState(() => checked = v),
);''',
    );
  }
}

/* ================= Text Input ================= */

class InputPage extends StatelessWidget {
  const InputPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const DemoPageLayout(
      title: "Text Input",
      demo: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Enter Name",
          prefixIcon: Icon(Icons.person),
          hintText: "John Doe",
        ),
      ),
      code: '''TextField(
  decoration: InputDecoration(
    border: OutlineInputBorder(),
    labelText: "Name",
  ),
);''',
    );
  }
}