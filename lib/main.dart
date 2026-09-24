import 'package:flutter/material.dart';
import 'flutter_bridge.dart'; // Impor FlutterBridge

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  // Fungsi untuk memulai
  void startScan() async {
    await FlutterBridge.startOcr();
    await FlutterBridge.getResult();
    // print("ocr Result: $result");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const OcrWidget(),
    );
  }
}

class OcrWidget extends StatefulWidget {
  const OcrWidget({super.key});

  @override
  OcrWidgetState createState() => OcrWidgetState();
}

class OcrWidgetState extends State<OcrWidget> {
  String ocrResult = "";

  // Fungsi untuk memulai scan
  void startScan() async {
    await FlutterBridge.startOcr();
    String result = await FlutterBridge.getResult();
    setState(() {
      ocrResult = result; // Simpan hasil ocr ke dalam state
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Building OcrWidget");
    return Scaffold(
      appBar: AppBar(
        title: const Text('OCR Scan'),
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
                child: const Text('Start OCR'),
              ),
              const SizedBox(height: 20),
              Text(
                ocrResult.isNotEmpty ? 'OCR Result: $ocrResult' : '',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
