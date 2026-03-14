import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/asset_provider.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  final String userRole;
  final String userName;
  const HomeScreen({super.key, required this.userRole, required this.userName});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<AssetProvider>().fetchAssets());
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AssetProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.userName, style: const TextStyle(fontSize: 18)),
            Text(
              "สิทธิ์: ${widget.userRole == 'admin' ? 'กรรมการ' : 'ลูกบ้าน'}",
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
        actions: [
          // ปุ่มดูรายการค้างส่ง (ทั้งลูกบ้านดูของตัวเอง และแอดมินดูทุกคน)
          IconButton(
            icon: const Icon(Icons.assignment_late),
            tooltip: 'รายการค้างส่ง',
            onPressed: () => _showPendingBorrows(),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
              onPressed: () => Navigator.pushReplacement(
              context, 
              MaterialPageRoute(builder: (_) => LoginScreen())
            ),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: provider.assets.length,
        itemBuilder: (context, i) {
          final item = provider.assets[i];
          bool isAvailable = item.remain > 0;

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("คงเหลือ: ${item.remain} / ${item.stock}\nหมวดหมู่: ${item.category}"),
              trailing: widget.userRole == 'admin'
                  ? null // แอดมินไม่ต้องมีปุ่มคืนที่นี่ ให้ไปคืนใน "รายการค้างส่ง" เพื่อระบุชื่อคนคืน
                  : ElevatedButton(
                      onPressed: isAvailable ? () => _showBorrowDialog(item) : null,
                      child: const Text("ยืม"),
                    ),
            ),
          );
        },
      ),
    );
  }

  // --- 1. Dialog ยืมของ (สำหรับลูกบ้าน) ---
  void _showBorrowDialog(item) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("ยืม ${item.name}"),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: "จำนวนที่ต้องการยืม"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("ยกเลิก")),
          ElevatedButton(
            onPressed: () {
              int amt = int.tryParse(controller.text) ?? 0;
              if (amt > 0 && amt <= item.remain) {
                context.read<AssetProvider>().borrowAsset(item.id!, amt, widget.userName);
                Navigator.pop(ctx);
              }
            },
            child: const Text("ตกลง"),
          ),
        ],
      ),
    );
  }

  // --- 2. หน้าต่างรายการค้างส่ง ---
  void _showPendingBorrows() async {
    final pendingList = await context.read<AssetProvider>().getPendingBorrows(
          widget.userRole == 'admin' ? null : widget.userName,
        );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text("📋 รายการวัสดุค้างส่ง", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const Divider(),
            Expanded(
              child: pendingList.isEmpty
                  ? const Center(child: Text("ไม่มีรายการค้างส่ง"))
                  : ListView.builder(
                      itemCount: pendingList.length,
                      itemBuilder: (context, i) {
                        final record = pendingList[i];
                        return Card(
                          color: Colors.orange.shade50,
                          child: ListTile(
                            title: Text("${record['asset_name']} (${record['amount']} ชิ้น)"),
                            subtitle: Text("ผู้ยืม: ${record['username']}\nวันที่ยืม: ${record['borrow_date']}"),
                            trailing: widget.userRole == 'admin'
                                ? ElevatedButton(
                                    onPressed: () => _handleReturn(record),
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                                    child: const Text("รับคืน"),
                                  )
                                : const Icon(Icons.timer, color: Colors.orange),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // --- 3. Dialog รับคืน (สำหรับแอดมินจัดการรายคน) ---
  void _handleReturn(Map<String, dynamic> record) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("รับคืนจาก ${record['username']}"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("พัสดุ: ${record['asset_name']}"),
            Text("จำนวนที่ยังค้าง: ${record['amount']} ชิ้น", style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 15),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "จำนวนที่รับคืนจริง", border: OutlineInputBorder()),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("ยกเลิก")),
          ElevatedButton(
            onPressed: () async {
              int returnAmt = int.tryParse(controller.text) ?? 0;
              int borrowedAmt = record['amount'];

              if (returnAmt > 0 && returnAmt <= borrowedAmt) {
                await context.read<AssetProvider>().returnFromRecord(
                      record['id'],
                      record['asset_id'],
                      returnAmt,
                      borrowedAmt,
                    );
                if (mounted) {
                  Navigator.pop(ctx); // ปิด Dialog
                  Navigator.pop(context); // ปิด BottomSheet เพื่อรีเฟรชข้อมูล
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("คืนของสำเร็จ")));
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("กรุณาระบุจำนวน 1-$borrowedAmt")),
                );
              }
            },
            child: const Text("ยืนยันการรับคืน"),
          ),
        ],
      ),
    );
  }
}