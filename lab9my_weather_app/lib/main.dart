import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple, // เปลี่ยนโทนสีให้ต่างจากเพื่อน
      ),
      home: const WeatherPage(),
    );
  }
}

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> with SingleTickerProviderStateMixin {
  double? temperature;
  double? windspeed;
  bool loading = true;
  String errorMessage = "";
  
  // 1. รายชื่อสถานที่ใหม่ตามที่คุณสั่ง (สะกดชื่อให้ตรงกับ selectedCity)
  String selectedCity = "Uttaradit"; 

  final Map<String, Map<String, double>> cities = {
    "Uttaradit": {"lat": 17.62, "lon": 100.09},
    "Nan": {"lat": 18.78, "lon": 100.77},
    "Chiang Mai": {"lat": 18.79, "lon": 98.98},
    "Doi Lo": {"lat": 18.47, "lon": 98.78},
  };

  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    // ปรับความเร็วการหมุนไอคอน (10 วินาทีต่อรอบ)
    controller = AnimationController(vsync: this, duration: const Duration(seconds: 10))..repeat();
    fetchWeather();
  }

  Future<void> fetchWeather() async {
    if (!mounted) return;
    setState(() {
      loading = true;
      errorMessage = "";
    });

    final lat = cities[selectedCity]!['lat'];
    final lon = cities[selectedCity]!['lon'];
    final url = Uri.parse(
        'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current_weather=true');
    
    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (mounted) {
          setState(() {
            temperature = data['current_weather']['temperature'];
            windspeed = data['current_weather']['windspeed'];
            loading = false;
          });
        }
      } else {
        setState(() {
          loading = false;
          errorMessage = "Error: ${response.statusCode}";
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          loading = false;
          errorMessage = "No Internet or API Down";
        });
      }
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("SkyCast Lab 9", 
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.deepPurple, Colors.blueAccent, Colors.white],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ไอคอนหมุนๆ (ใช้ Icons.filter_drama ให้ดูต่างจากเพื่อน)
            RotationTransition(
              turns: controller,
              child: const Icon(Icons.filter_drama, size: 100, color: Colors.white),
            ),
            const SizedBox(height: 20),
            
            // Dropdown เลือกเมือง
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedCity,
                  dropdownColor: Colors.deepPurpleAccent,
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
                  iconEnabledColor: Colors.white,
                  items: cities.keys.map((String city) {
                    return DropdownMenuItem(value: city, child: Text(city));
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => selectedCity = val);
                      fetchWeather();
                    }
                  },
                ),
              ),
            ),
            
            const SizedBox(height: 30),

            // การแสดงผลข้อมูล (เช็ก Loading และ Error)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Card(
                elevation: 15,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: loading 
                    ? const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 10),
                          Text("Loading Weather..."),
                        ],
                      )
                    : errorMessage.isNotEmpty
                      ? Text(errorMessage, style: const TextStyle(color: Colors.red))
                      : Column(
                          children: [
                            const Text("LOCAL TEMPERATURE", 
                              style: TextStyle(letterSpacing: 1.2, color: Colors.grey, fontWeight: FontWeight.bold)),
                            Text(
                              "$temperature°",
                              style: const TextStyle(fontSize: 70, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                            ),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.air, color: Colors.blue),
                                const SizedBox(width: 8),
                                Text("Wind: $windspeed km/h", style: const TextStyle(fontSize: 16)),
                              ],
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}