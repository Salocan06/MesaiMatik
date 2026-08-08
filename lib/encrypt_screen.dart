import 'package:flutter/material.dart';
import 'models.dart';
import 'lang.dart';

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
      setState(() => message = t('pinMinLengthError'));
      return;
    }
    if (newPinCtrl.text != confirmPinCtrl.text) {
      setState(() => message = t('pinMismatchError'));
      return;
    }
    widget.onSave(widget.settings.copyWith(pinCode: newPinCtrl.text));
    setState(() {
      message = t('pinSavedMessage');
      newPinCtrl.clear();
      confirmPinCtrl.clear();
    });
  }

  void _removePin() {
    if (currentPinCtrl.text != widget.settings.pinCode) {
      setState(() => message = t('wrongCurrentPinError'));
      return;
    }
    widget.onSave(widget.settings.copyWith(clearPin: true));
    setState(() {
      message = t('pinRemovedMessage');
      currentPinCtrl.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(t('encryptScreenTitle'))),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasPin) ...[
              Text(t('pinActiveMessage'),
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
              const SizedBox(height: 16),
              Text(t('enterCurrentPinToRemove')),
              const SizedBox(height: 8),
              TextField(
                controller: currentPinCtrl,
                obscureText: true,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: t('currentPinLabel')),
              ),
              const SizedBox(height: 12),
              ElevatedButton(onPressed: _removePin, child: Text(t('removePinButton'))),
              const Divider(height: 32),
            ] else ...[
              Text(t('pinNotActiveMessage'),
                  style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 16),
            ],
            Text(hasPin ? t('changePinTitle') : t('newPinTitle'),
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: newPinCtrl,
              obscureText: true,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: t('newPinLabel')),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: confirmPinCtrl,
              obscureText: true,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: t('confirmPinLabel')),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
                onPressed: _setPin,
                child: Text(hasPin ? t('updatePinButton') : t('setPinButton'))),
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
