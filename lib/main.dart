import 'package:flutter/material.dart';
import 'home_page.dart';
import 'name.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

   @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'سبحة | Sebha',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/', // Define the initial route
      routes: {
        '/': (context) => NamePage(),
        '/home': (context) => const MyHomePage(title: 'السبحة الذكية للاذكار'),
      },
    );
  }
}



