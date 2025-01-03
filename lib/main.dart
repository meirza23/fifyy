import 'package:flutter/material.dart';
import 'ui/splash_screen.dart'; // SplashScreen'i çağırıyoruz

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FIFYY App',
      theme: ThemeData(
        fontFamily:
            'SubstanceMedium', // Varsayılan font olarak SubstanceMedium kullanıyoruz
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(), // SplashScreen ilk açılan ekran
    );
  }
}
