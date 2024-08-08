import 'package:flutter/material.dart';
import 'package:just_music/homepage.dart';
import 'package:just_music/splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false, 
        home:  SplashScreen());
  }
}
