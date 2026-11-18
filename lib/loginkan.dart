import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'navbar.dart';

const String kPassword = 'pw';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailC = TextEditingController();
  final _passC = TextEditingController();

  @override
  void dispose() {
    _emailC.dispose();
    _passC.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final email = _emailC.text.trim();
    if (email.isEmpty) return _msg('Email tidak boleh kosong');
    if (!email.contains('@')) return _msg('Format email tidak valid');
    if (_passC.text != kPassword) return _msg('Password salah (gunakan "pw")');

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    if (!mounted) return;
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => MainPage(username: email)));
  }

  void _msg(String s) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(children: [
            const Icon(Icons.backpack,
                size: 80, color: Color.fromARGB(255, 63, 181, 69)),
            const Text('Shopedia',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            TextField(
              controller: _emailC,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                  labelText: 'Email', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passC,
              obscureText: true,
              decoration: const InputDecoration(
                  labelText: 'Password ("pw")', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(onPressed: _login, child: const Text('Login')),
            ),
          ]),
        ),
      ),
    );
  }
}
