import 'package:flutter/material.dart';
import 'models.dart';

class EncryptScreen extends StatefulWidget {
  final AppSettings settings;
  final void Function(AppSettings) onSave;

  const EncryptScreen({super.key, required this.settings, required this.onSave});

  @override
  State<EncryptScreen> createState() => _EncryptScreenState();
}

class _EncryptScreenState extends State<EncryptScreen> {
  final TextEditingController newPinCtrl = TextEditingController();
  final TextEditingController confirmPinCtrl = TextEditingController();
  final TextEditingController currentPinCtrl = TextEditingController();
  String? message;

  bool get hasPin =>
      widget.settings.pinCode != null && widget.settings.pinCode!.isNotEmpty;

  void _setPin() {
    if (newPinCtrl.text.isEmpty || newPinCtrl.text.length < 4) {
      setState(() => message = 'PIN en az 4 haneli olmali');
      return;
    }
    if (newPinCtrl.text != confirmPinCtrl.text) {
      setState(() => message = 'PIN ler eslesmiyor');
      return;
    }
    widget.onSave(widget.settings.copyWith(pinCode: newPinCtrl.text));
    setState(() {
      message = 'PIN kaydedildi. Uygulama bir sonraki acilista PIN isteyecek.';
      newPinCtrl.clear();
      confirmPinCtrl.clear();
    });
  }

  void _removePin() {
    if (currentPinCtrl.text != widget.settings.pinCode) {
      setState(() => message = 'Mevcut PIN yanlis');
      return;
    }
    widget.onSave(widget.settings.copyWith(clearPin: true));
    setState(() {
      message = 'PIN kaldirildi.';
      currentPinCtrl.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Programi Sifrele')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasPin) ...[
              const Text('Uygulama su an PIN ile korunuyor.',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
              const SizedBox(height: 16),
              const Text('PIN i kaldirmak icin mevcut PIN i girin:'),
              const SizedBox(height: 8),
              TextField(
                controller: currentPinCtrl,
                obscureText: true,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Mevcut PIN'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(onPressed: _removePin, child: const Text('PIN i Kaldir')),
              const Divider(height: 32),
            ] else ...[
              const Text('Uygulama su an PIN ile korunmuyor.',
                  style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 16),
            ],
            Text(hasPin ? 'PIN i degistir:' : 'Yeni bir PIN belirleyin (4 haneli):',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: newPinCtrl,
              obscureText: true,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Yeni PIN'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: confirmPinCtrl,
              obscureText: true,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Yeni PIN (tekrar)'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
                onPressed: _setPin,
                child: Text(hasPin ? 'PIN i Guncelle' : 'PIN Belirle')),
            if (message != null) ...[
              const SizedBox(height: 16),
              Text(message!, style: const TextStyle(color: Colors.orange)),
            ],
          ],
        ),
      ),
    );
  }
}