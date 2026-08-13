import 'dart:async';
import 'package:flutter/material.dart';

class PromoScreen extends StatefulWidget {
  final VoidCallback onDone;

  const PromoScreen({super.key, required this.onDone});

  @override
  State<PromoScreen> createState() => _PromoScreenState();
}

class _PromoScreenState extends State<PromoScreen> {
  Timer? _timer;
  int secondsLeft = 5;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        secondsLeft -= 1;
      });
      if (secondsLeft <= 0) {
        timer.cancel();
        widget.onDone();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'IMG_20260813_150050.jpg',
                fit: BoxFit.contain,
              ),
            ),
            Positioned(
              top: 12,
              right: 12,
              child: GestureDetector(
                onTap: widget.onDone,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (secondsLeft > 0)
                        Padding(
                          padding: const EdgeInsets.only(left: 6, right: 4),
                          child: Text(
                            '$secondsLeft',
                            style: const TextStyle(
                                color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      const Icon(Icons.close, color: Colors.white, size: 22),
                      const SizedBox(width: 4),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
