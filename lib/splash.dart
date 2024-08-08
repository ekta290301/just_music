import 'package:flutter/material.dart';
import 'package:just_music/homepage.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(Duration(seconds: 3), () {}); // Reduce for debugging
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MyAudioPlayer()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/musiclogoooooo.png', height: 100), // Ensure path is correct
            SizedBox(height: 20),
            Text('lets play', style: TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}
