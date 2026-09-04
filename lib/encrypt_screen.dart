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

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Text(text, style: TextStyle(fontSize: 15, color: Colors.grey.shade500)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(t('encryptScreenTitle'))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: (hasPin ? Colors.green : Colors.grey).withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: hasPin ? Colors.green : Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(hasPin ? Icons.shield_outlined : Icons.shield_moon_outlined,
                        size: 19, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      hasPin ? t('pinActiveMessage') : t('pinNotActiveMessage'),
                      style: TextStyle(
                          fontSize: 13,
                          color: hasPin ? Colors.green : Colors.grey.shade500,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
            if (hasPin) ...[
              _sectionLabel(t('enterCurrentPinToRemove')),
              TextField(
                controller: currentPinCtrl,
                obscureText: true,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: t('currentPinLabel')),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _removePin,
                  style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red, side: const BorderSide(color: Colors.red)),
                  child: Text(t('removePinButton')),
                ),
              ),
            ],
            _sectionLabel(hasPin ? t('changePinTitle') : t('newPinTitle')),
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
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _setPin,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                child: Text(hasPin ? t('updatePinButton') : t('setPinButton')),
              ),
            ),
            if (message != null) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(message!,
                    style: const TextStyle(color: Colors.orange, fontSize: 12)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
