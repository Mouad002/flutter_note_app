import 'package:flutter/material.dart';
import 'package:notes_app/view/home.dart';
import 'package:notes_app/view/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences sharedPreferences;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'notes_app',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: sharedPreferences.getString('user_id') == null ? LoginPage(): HomePage(),
    );
  }
}
