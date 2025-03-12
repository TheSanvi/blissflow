import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnxietyReliefScreen extends StatefulWidget {
  const AnxietyReliefScreen({Key? key}) : super(key: key);

  @override
  _AnxietyReliefScreenState createState() => _AnxietyReliefScreenState();
}

class _AnxietyReliefScreenState extends State<AnxietyReliefScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Timer _timer;
  int _breathCycle = 0;
  bool _isInhaling = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4), // 4 seconds inhale/exhale
      lowerBound: 0.8,
      upperBound: 1.2,
    )..repeat(reverse: true);

    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      setState(() {
        _isInhaling = !_isInhaling;
        _breathCycle++;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Anxiety Relief"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _isInhaling ? "Inhale..." : "Exhale...",
              style: GoogleFonts.lato(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 20),
            ScaleTransition(
              scale: _animationController,
              child: Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blueAccent,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              "Breath Cycles: $_breathCycle",
              style: GoogleFonts.lato(fontSize: 18, color: Colors.white70),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.blue.shade900,
    );
  }
}
