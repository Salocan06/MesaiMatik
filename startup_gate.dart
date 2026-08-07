import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models.dart';
import 'pin_lock_screen.dart';
import 'main.dart';

class StartupGate extends StatefulWidget {
  const StartupGate({super.key});

  @override
  State<StartupGate> createState() => _StartupGateState();
}

class _StartupGateState extends State<StartupGate> {
  bool loading = true;
  String? pinCode;

  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<void> _check() async {
    final prefs = await SharedPreferences.getInstance();
    final settingsStr = prefs.getString('settings');
    String? pin;
    if (settingsStr != null) {
      final s = AppSettings.fromJson(jsonDecode(settingsStr));
      pin = s.pinCode;
    }
    setState(() {
      pinCode = pin;
      loading = false;
    });
  }

  void _unlocked() {
    setState(() {
      pinCode = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (pinCode != null && pinCode!.isNotEmpty) {
      return PinLockScreen(correctPin: pinCode!, onUnlocked: _unlocked);
    }
    return const MainMenuScreen();
  }
}