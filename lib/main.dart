import 'package:flutter/material.dart';
import 'home_page.dart'; // นำเข้า home_page.dart

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pig Wallet',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WelcomeScreen(),
    );
  }
}

// เปลี่ยนจาก StatelessWidget เป็น StatefulWidget
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    // หลังจาก 3 วินาที ให้เปลี่ยนหน้าไปยัง HomePage
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFB3E5FC),
              Color.fromARGB(255, 255, 197, 227),
              Color.fromARGB(255, 249, 249, 249),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ไอคอนแอป
              Image.asset(
                'assets/pig_wallet.png',
                height: 250,
                width: 250,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20), // ระยะห่างระหว่างไอคอนและข้อความ
              // ข้อความ Welcome to Pig Wallet
              const Text(
                'Welcome to Pig Wallet',
                style: TextStyle(
                  fontSize: 24,
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}