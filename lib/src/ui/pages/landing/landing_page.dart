import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  void initState() {
    fetchCatBreeds();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            Text('Cat Breeds...'),
          ],
        ),
      ),
    );
  }

  Future fetchCatBreeds() async {
    Future.delayed(const Duration(seconds: 4), () {
      FlutterNativeSplash.remove();
    });
  }
}
