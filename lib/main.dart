import 'package:azer/login_page.dart';
import 'package:flutter/material.dart';

var afficheTexte = const Text("Hello World",
style:TextStyle(
  color:Colors.green,
  fontSize: 20,
  fontWeight: FontWeight.bold,
),
);
//var IIcon = const Icon(Icons.mail,
//color: Colors.blue,);

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}