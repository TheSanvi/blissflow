import 'package:flutter/material.dart';

class BreathingExerciseScreen extends StatelessWidget {
  const BreathingExerciseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Breathing Exercise')),
      body: Center(
        child: Text('This is the Breathing Exercise Screen'),
      ),
    );
  }
}
