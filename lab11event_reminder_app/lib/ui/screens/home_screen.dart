import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/event_provider.dart';
import 'add_event_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // เรียกใช้ชื่อที่ตรงกับใน Provider
    Future.microtask(() => context.read<EventProvider>().seedInitialCategories());
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EventProvider>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Event Reminder"),
        backgroundColor: Colors.blue.shade100,
      ),
      body: provider.events.isEmpty 
        ? const Center(child: Text("ยังไม่มีกิจกรรม กดปุ่ม + เพื่อเพิ่ม"))
        : ListView.builder(
            itemCount: provider.events.length,
            itemBuilder: (context, i) {
              final ev = provider.events[i];
              // แปลงสีจาก Hex String เป็น Color object
              final catColor = Color(int.parse(ev['catColor'].replaceAll('#', '0xff')));

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: catColor,
                    child: const Icon(Icons.event, color: Colors.white),
                  ),
                  title: Text(ev['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("${ev['catName']} \n${ev['event_date']} | ${ev['start_time']} - ${ev['end_time']}"),
                  isThreeLine: true,
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(ev['status'], style: TextStyle(color: _getStatusColor(ev['status']), fontWeight: FontWeight.bold)),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                  onLongPress: () => _showDeleteDialog(ev['id'], ev['title']),
                ),
              );
            },
          ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddEventScreen())),
        child: const Icon(Icons.add),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Completed': return Colors.green;
      case 'In Progress': return Colors.blue;
      case 'Cancelled': return Colors.red;
      default: return Colors.orange;
    }
  }

  void _showDeleteDialog(int id, String title) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("ยืนยันการลบ"),
        content: Text("คุณต้องการลบกิจกรรม '$title' ใช่หรือไม่?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("ยกเลิก")),
          TextButton(onPressed: () {
            context.read<EventProvider>().deleteEvent(id);
            Navigator.pop(ctx);
          }, child: const Text("ลบ", style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }
}