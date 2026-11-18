import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'loginkan.dart';
import 'navbar.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('cart');
  final prefs = await SharedPreferences.getInstance();
  runApp(MyApp(email: prefs.getString('email')));
}

class MyApp extends StatelessWidget {
  final String? email;
  const MyApp({super.key, this.email});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopedia',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: email == null ? const LoginPage() : MainPage(username: email!),
    );
  }
}
