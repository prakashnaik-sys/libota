import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KavitaLoginScreen extends StatefulWidget {
  const KavitaLoginScreen({super.key});

  @override
  State<KavitaLoginScreen> createState() => _KavitaLoginScreenState();
}

class _KavitaLoginScreenState extends State<KavitaLoginScreen> {
  final urlCtrl = TextEditingController();
  final keyCtrl = TextEditingController();

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('kavita_url', urlCtrl.text);
    await prefs.setString('kavita_key', keyCtrl.text);
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kavita Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: urlCtrl,
              decoration: const InputDecoration(labelText: 'Server URL'),
            ),
            TextField(
              controller: keyCtrl,
              decoration: const InputDecoration(labelText: 'API Key'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: save, child: const Text('Save')),
          ],
        ),
      ),
    );
  }
}
