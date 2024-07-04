import 'dart:convert';
import 'package:azer/api_service.dart';
import 'package:flutter/material.dart';

// import 'package:azer/home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ApiService apiService = ApiService();

  void _login() async {
    try {
      final response = await apiService.login(
        emailController.text,
        passwordController.text,
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        apiService.setCurrentUser(responseBody['id'], responseBody['role']);
        print('Login successful. User ID: ${responseBody['id']}');
        print('User Role: ${responseBody['role']}');

        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => HomePage()),
        // );
      } else {
        _showErrorDialog('Erreur de connexion', 'Les coordonnées sont incorrectes. Veuillez réessayer.');
      }
    } catch (e) {
      _showErrorDialog('Erreur de connexion', 'Une erreur s\'est produite. Veuillez réessayer.');
    }
  }

  void _showErrorDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
