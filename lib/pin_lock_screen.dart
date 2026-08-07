import 'package:flutter/material.dart';

class PinLockScreen extends StatefulWidget {
  final String correctPin;
  final VoidCallback onUnlocked;

  const PinLockScreen({super.key, required this.correctPin, required this.onUnlocked});

  @override
  State<PinLockScreen> createState() => _PinLockScreenState();
}

class _PinLockScreenState extends State<PinLockScreen> {
  final TextEditingController pinCtrl = TextEditingController();
  String? error;

  void _check() {
    if (pinCtrl.text == widget.correctPin) {
      widget.onUnlocked();
    } else {
      setState(() => error = 'Yanlis PIN, tekrar deneyin');
      pinCtrl.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock, size: 64, color: Colors.indigo),
              const SizedBox(height: 16),
              const Text('Mesaimatik Kilitli',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              TextField(
                controller: pinCtrl,
                obscureText: true,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(labelText: 'PIN girin'),
                onSubmitted: (_) => _check(),
              ),
              if (error != null) ...[
                const SizedBox(height: 8),
                Text(error!, style: const TextStyle(color: Colors.red)),
              ],
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _check, child: const Text('Ac')),
            ],
          ),
        ),
      ),
    );
  }
}