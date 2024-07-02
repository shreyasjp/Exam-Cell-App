import 'package:flutter/material.dart';
import 'screens/login_page.dart' as Login;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final Duration duration = const Duration(seconds: 2);
  @override
  void initState() {
    super.initState();
    Future.delayed(duration, () {
      Login.main();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 8, top: 8),
          child: Text(
            'Copyright 2024 | Don Xavier',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
            ),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                'assets/app_icon.png',
                width: 150,
                height: 150,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'St. Paul\' College\nKalamassery',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ));
  }
}
