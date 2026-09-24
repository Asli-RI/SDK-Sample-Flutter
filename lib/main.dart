import 'package:flutter/material.dart';
import 'flutter_bridge.dart'; // Impor FlutterBridge

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  // Fungsi untuk memulai liveness
  void startScan() async {
    await FlutterBridge.startLiveness();
    await FlutterBridge.getResult();
    // print("liveness Result: $result");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const LivenessWidget(),
    );
  }
}

class LivenessWidget extends StatefulWidget {
  const LivenessWidget({super.key});

  @override
  LivenessWidgetState createState() => LivenessWidgetState();
}

class LivenessWidgetState extends State<LivenessWidget> {
  String livenessResult = "";

  // Fungsi untuk memulai scan liveness
  void startScan() async {
    await FlutterBridge.startLiveness();
    String result = await FlutterBridge.getResult();
    setState(() {
      livenessResult = result; // Simpan hasil liveness ke dalam state
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Building LivenessWidget");
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liveness Scan'),
      ),
      body: Container(
        color: Colors.white, // Tambahkan warna untuk memastikan elemen tampil
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: startScan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF12A37),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Start smile liveness'),
              ),
              const SizedBox(height: 20),
              Text(
                livenessResult.isNotEmpty
                    ? 'Liveness Result: $livenessResult'
                    : '',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
