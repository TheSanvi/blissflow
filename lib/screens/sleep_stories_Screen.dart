import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SleepStoriesScreen extends StatelessWidget {
  const SleepStoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sleep Stories"),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildStoryCard("Ocean Waves", "A soothing story with ocean sounds."),
          _buildStoryCard("Rainy Night", "Sleep with the calming sound of rain."),
          _buildStoryCard("Forest Dreams", "Feel the peace of the forest."),
        ],
      ),
    );
  }

  Widget _buildStoryCard(String title, String description) {
    return Card(
      color: Colors.blue[50],
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: const Icon(Icons.nightlight_round, color: Colors.blue),
        title: Text(title, style: GoogleFonts.lato(fontWeight: FontWeight.bold)),
        subtitle: Text(description, style: GoogleFonts.lato()),
        trailing: const Icon(Icons.play_circle_outline, color: Colors.blueAccent),
        onTap: () {},
      ),
    );
  }
}

class FocusSessionScreen extends StatefulWidget {
  const FocusSessionScreen({Key? key}) : super(key: key);

  @override
  _FocusSessionScreenState createState() => _FocusSessionScreenState();
}

class _FocusSessionScreenState extends State<FocusSessionScreen> {
  int _seconds = 1500; // 25 minutes
  bool _isRunning = false;

  void _startTimer() {
    setState(() {
      _isRunning = !_isRunning;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Focus Session"),
        backgroundColor: Colors.greenAccent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "${(_seconds ~/ 60).toString().padLeft(2, '0')}:${(_seconds % 60).toString().padLeft(2, '0')}",
            style: GoogleFonts.lato(fontSize: 48, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _startTimer,
            child: Text(_isRunning ? "Pause" : "Start"),
          ),
        ],
      ),
    );
  }
}

class AnxietyReliefScreen extends StatelessWidget {
  const AnxietyReliefScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Anxiety Relief"),
        backgroundColor: Colors.redAccent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildExerciseCard("Deep Breathing", "Inhale for 4s, hold for 4s, exhale for 4s."),
          _buildExerciseCard("Body Scan", "Relax every muscle one by one."),
          _buildExerciseCard("Visualization", "Imagine a peaceful place."),
        ],
      ),
    );
  }

  Widget _buildExerciseCard(String title, String description) {
    return Card(
      color: Colors.red[50],
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: const Icon(Icons.self_improvement, color: Colors.red),
        title: Text(title, style: GoogleFonts.lato(fontWeight: FontWeight.bold)),
        subtitle: Text(description, style: GoogleFonts.lato()),
        trailing: const Icon(Icons.play_circle_outline, color: Colors.redAccent),
        onTap: () {},
      ),
    );
  }
}
