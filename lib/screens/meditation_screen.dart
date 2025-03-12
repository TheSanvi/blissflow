import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:intl/intl.dart';

class MeditationScreen extends StatefulWidget {
  @override
  _MeditationScreenState createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen> {
  Timer? _timer;
  int _seconds = 0;
  bool _isRunning = false;
  Database? _database;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  String _selectedSound = 'rain.mp3';
  final List<String> _soundOptions = ['rain.mp3', 'ocean.mp3', 'forest.mp3'];
  final List<Map<String, dynamic>> _popularMeditations = [
    {"title": "Deep Sleep", "icon": Icons.nightlight_round},
    {"title": "Morning Boost", "icon": Icons.wb_sunny},
    {"title": "Stress Release", "icon": Icons.self_improvement},
  ];

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'meditation_sessions.db'),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE sessions(id INTEGER PRIMARY KEY AUTOINCREMENT, duration INTEGER, date TEXT)');
      },
      version: 1,
    );
  }

  void _startTimer() {
    setState(() => _isRunning = true);
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() => _seconds++);
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() => _isRunning = false);
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _seconds = 0;
    });
  }

  void _toggleSound() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(AssetSource('sounds/$_selectedSound'));
    }
    setState(() => _isPlaying = !_isPlaying);
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good Morning";
    if (hour < 18) return "Good Afternoon";
    return "Good Evening";
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade900, Colors.greenAccent.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  _getGreeting(),
                  style: GoogleFonts.lato(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),

                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/avatar_placeholder.png'),
                ),
                SizedBox(height: 20),

                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  color: Colors.white.withOpacity(0.2),
                  child: ListTile(
                    title: Text(
                      "Today's Recommendation: Mindfulness Meditation",
                      style: GoogleFonts.lato(color: Colors.white, fontSize: 16),
                    ),
                    trailing: Icon(Icons.lightbulb_outline, color: Colors.white),
                  ),
                ),
                SizedBox(height: 20),

                Text("Quick Actions",
                    style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white)),
                SizedBox(height: 10),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: [
                    _quickActionButton("Breathing", Icons.air),
                    _quickActionButton("Sleep Stories", Icons.nightlight_round),
                    _quickActionButton("Focus Mode", Icons.center_focus_strong),
                    _quickActionButton("Anxiety Relief", Icons.self_improvement),
                  ],
                ),
                SizedBox(height: 20),

                Text("Popular Meditations",
                    style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white)),
                SizedBox(height: 10),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: _popularMeditations.map((meditation) {
                    return _meditationCard(meditation["title"], meditation["icon"]);
                  }).toList(),
                ),
                SizedBox(height: 20),

                CircularPercentIndicator(
                  radius: 120.0,
                  lineWidth: 12.0,
                  percent: (_seconds % 60) / 60.0,
                  center: Text(
                    _formatTime(_seconds),
                    style: GoogleFonts.lato(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  progressColor: Colors.white,
                  backgroundColor: Colors.white24,
                  circularStrokeCap: CircularStrokeCap.round,
                ),
                SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _controlButton(Icons.play_arrow, _isRunning ? null : _startTimer),
                    _controlButton(Icons.pause, _isRunning ? _pauseTimer : null),
                    _controlButton(Icons.stop, _stopTimer),
                  ],
                ),
                SizedBox(height: 20),

                DropdownButton<String>(
                  dropdownColor: Colors.teal.shade800,
                  style: GoogleFonts.lato(color: Colors.white),
                  value: _selectedSound,
                  items: _soundOptions
                      .map((sound) => DropdownMenuItem(
                    child: Text(sound),
                    value: sound,
                  ))
                      .toList(),
                  onChanged: (val) => setState(() => _selectedSound = val!),
                ),
                SizedBox(height: 10),

                ElevatedButton(
                  onPressed: _toggleSound,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white.withOpacity(0.3)),
                  child: Text(
                    _isPlaying ? "Pause Sound" : "Play Sound",
                    style: GoogleFonts.lato(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _quickActionButton(String text, IconData icon) {
    return _meditationCard(text, icon);
  }

  Widget _meditationCard(String title, IconData icon) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white.withOpacity(0.2),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {},
        child: Container(
          width: 140,
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 28),
              SizedBox(height: 8),
              Text(title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(color: Colors.white, fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _controlButton(IconData icon, VoidCallback? onPressed) {
    return IconButton(
      icon: Icon(icon, size: 32, color: Colors.white),
      onPressed: onPressed,
    );
  }
}
