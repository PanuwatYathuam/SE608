import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../state/event_provider.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 10, minute: 0);
  int _selectedCategoryId = 1;
  double _priority = 2; // Normal

  // ฟังก์ชันเช็คเวลา (Validation) ตามโจทย์เป๊ะๆ
  bool _isTimeValid() {
    final start = _startTime.hour * 60 + _startTime.minute;
    final end = _endTime.hour * 60 + _endTime.minute;
    return end > start;
  }

  void _saveEvent() {
    if (_formKey.currentState!.validate()) {
      if (!_isTimeValid()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("เวลาสิ้นสุดต้องมากกว่าเวลาเริ่ม!")),
        );
        return;
      }

      final newEvent = {
        'title': _titleController.text,
        'description': _descController.text,
        'category_id': _selectedCategoryId,
        'event_date': DateFormat('yyyy-MM-dd').format(_selectedDate),
        'start_time': _startTime.format(context),
        'end_time': _endTime.format(context),
        'priority': _priority.toInt(),
        'status': 'Pending',
      };

      context.read<EventProvider>().addEvent(newEvent);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = context.watch<EventProvider>().categories;

    return Scaffold(
      appBar: AppBar(title: const Text("เพิ่มกิจกรรมใหม่")),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: "ชื่อกิจกรรม *", border: OutlineInputBorder()),
              validator: (v) => v!.isEmpty ? "กรุณากรอกชื่อกิจกรรม" : null,
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField(
              value: _selectedCategoryId,
              items: categories.map((c) => DropdownMenuItem(
                value: c['id'], 
                child: Text(c['name']),
              )).toList(),
              onChanged: (val) => setState(() => _selectedCategoryId = val as int),
              decoration: const InputDecoration(labelText: "หมวดหมู่", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 15),
            ListTile(
              title: Text("วันที่: ${DateFormat('dd/MM/yyyy').format(_selectedDate)}"),
              trailing: const Icon(Icons.calendar_month),
              onTap: () async {
                final picked = await showDatePicker(context: context, initialDate: _selectedDate, firstDate: DateTime.now(), lastDate: DateTime(2030));
                if (picked != null) setState(() => _selectedDate = picked);
              },
            ),
            Row(
              children: [
                Expanded(child: ListTile(
                  title: const Text("เริ่ม"),
                  subtitle: Text(_startTime.format(context)),
                  onTap: () async {
                    final t = await showTimePicker(context: context, initialTime: _startTime);
                    if (t != null) setState(() => _startTime = t);
                  },
                )),
                Expanded(child: ListTile(
                  title: const Text("สิ้นสุด"),
                  subtitle: Text(_endTime.format(context)),
                  onTap: () async {
                    final t = await showTimePicker(context: context, initialTime: _endTime);
                    if (t != null) setState(() => _endTime = t);
                  },
                )),
              ],
            ),
            const SizedBox(height: 15),
            const Text("ระดับความสำคัญ (1=ต่ำ, 2=ปกติ, 3=สูง)"),
            Slider(
              value: _priority,
              min: 1, max: 3, divisions: 2,
              label: _priority.toInt().toString(),
              onChanged: (v) => setState(() => _priority = v),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50), backgroundColor: Colors.blue, foregroundColor: Colors.white),
              onPressed: _saveEvent,
              child: const Text("บันทึกกิจกรรม"),
            )
          ],
        ),
      ),
    );
  }
}