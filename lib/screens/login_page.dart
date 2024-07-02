import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'student_dashboard.dart';
import 'teacher_dashboard.dart';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      theme: ThemeData(
          primarySwatch: Colors.blue, scaffoldBackgroundColor: Colors.white),
      debugShowCheckedModeBanner: false, // Remove debug banner
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> loginUser(BuildContext context) async {
    final String username = usernameController.text;
    final String password = passwordController.text;

    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.16:8000/login/'),
        body: {'username': username, 'password': password},
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        String userType = data['user_type'];
        String userName = data['name'];
        String userPrn = data['prn'];
        String userDept = data['department'];
        String userLevel = '';
        String userBatch = '';
        List<String> userNotify = List<String>.from(data['notification']);
        List<Map<String, dynamic>> userAlloc = [];
        if (userType == 'Student') {
          userAlloc =
              List<Map<String, dynamic>>.from(data['student_allocations']);
          userLevel = data['level'];
          userBatch = data['batch'];
        } else {
          userAlloc =
              List<Map<String, dynamic>>.from(data['teacher_allocations']);
          List<dynamic> exchangeRequest = data['exchangeRequest'] ?? '';

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TeacherDashboard(
                userType: userType,
                userDept: userDept,
                userName: userName,
                userPrn: userPrn,
                userNotify: userNotify,
                userAlloc: userAlloc,
                exchangeRequest: exchangeRequest,
              ),
            ),
          );
          return; // Add this return statement to exit the function after navigating
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StudentDashboard(
              userType: userType,
              userDept: userDept,
              userName: userName,
              userPrn: userPrn,
              userNotify: userNotify,
              userAlloc: userAlloc,
              userLevel: userLevel,
              userBatch: userBatch,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Invalid username or password'),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error occurred while logging in:$e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      /* bottomSheet: Container(
        color: Colors.white,
        child: const Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: Text(
            'Copyright \u00A9 2024 | Don Xavier',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
            ),
          ),
        ),
      ), */
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  'assets/app_icon.png',
                  width: 150,
                  height: 150,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Sign In to access your dashboard',
                  style: TextStyle(fontSize: 30),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                TextFormField(
                  controller: usernameController,
                  style: const TextStyle(fontSize: 16),
                  decoration: const InputDecoration(
                    labelText: 'User ID',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'User ID is your PRN or Staff ID',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: passwordController,
                  style: const TextStyle(fontSize: 16),
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      loginUser(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      backgroundColor: const Color(0xFF004AAD),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
