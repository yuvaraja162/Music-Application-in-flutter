import 'package:flutter/material.dart';
import 'Hompage.dart';
import 'Player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (context) => const Homepage(),
        '/player': ((context) => const muplayer())
      },
    );
  }
}
