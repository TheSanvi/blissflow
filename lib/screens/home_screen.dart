
import 'package:blissflow/screens/emergency_screen.dart';
import 'package:blissflow/screens/hydration_screen.dart';
import 'package:blissflow/screens/journalling_screen.dart';
import 'package:blissflow/screens/meditation_screen.dart';
import 'package:blissflow/screens/mood_screen.dart';
import 'package:blissflow/screens/profile_screen.dart';
import 'package:blissflow/screens/settings_screen.dart';
import 'package:blissflow/screens/sleep_tracking_screen.dart';
import 'package:blissflow/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreenContent(),
    MoodScreen(),
    ProfileScreen(),
    SettingsScreen(),
    EmergencyScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigation(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}

class HomeScreenContent extends StatefulWidget {
  @override
  _HomeScreenContentState createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  Future<void> _saveMood(String mood) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> moodHistory = prefs.getStringList('moodHistory') ?? [];
    String todayMood = jsonEncode({'date': DateTime.now().toString(), 'mood': mood});
    moodHistory.add(todayMood);

    if (moodHistory.length > 7) {
      moodHistory.removeAt(0);
    }

    await prefs.setStringList('moodHistory', moodHistory);
  }

  Future<List<Map<String, String>>> _getMoodHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> moodHistory = prefs.getStringList('moodHistory') ?? [];
    return moodHistory.map((e) => Map<String, String>.from(jsonDecode(e))).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFE8D3F5), Color(0xFFF5CBED)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Good evening',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Monday, February 10',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                  Lottie.asset(
                    'assests/Animation - 1740593647235.json',
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('How are you feeling today?'),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MoodScreen()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: _containerDecoration(const Color(0xFF7C4DFF).withOpacity(0.1)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMoodIcon('😊', 'Great'),
                      _buildMoodIcon('🙂', 'Good'),
                      _buildMoodIcon('😐', 'Okay'),
                      _buildMoodIcon('😔', 'Down'),
                      _buildMoodIcon('😢', 'Awful'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('Quick Actions'),
              Row(
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      alignment: WrapAlignment.start,
                      children: [
                        _buildQuickActionCard(context, 'Journal', Icons.edit_note, 'Write your thoughts', Colors.blue, JournalScreen()),
                        _buildQuickActionCard(context, 'Meditate', Icons.self_improvement, '10 min session', Colors.purple, MeditationScreen()),
                        _buildQuickActionCard(context, 'Hydration', Icons.water_drop, 'Track water intake', Colors.cyan, HydrationScreen()),
                        _buildQuickActionCard(context, 'Sleep', Icons.bedtime, 'Track sleep quality', Colors.indigo, SleepScreen()),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Lottie.asset(
                      'assests/Animation - 1740595749959.json',
                      height: 180,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('Weekly Overview'),
              _buildOverviewCard('Mood Trend', 'Improving', Icons.trending_up, Colors.green),
              _buildOverviewCard('Meditation', '22 mins', Icons.timer, Colors.purple),
              _buildOverviewCard('Hydration', '1.8L/2L', Icons.water_drop, Colors.blue),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoodIcon(String emoji, String label) {
    return GestureDetector(
      onTap: () async {
        await _saveMood(label);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Mood Saved: $label"), duration: Duration(seconds: 1)),
        );
      },
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildQuickActionCard(BuildContext context, String title, IconData icon, String subtitle, Color color, Widget screen) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
      },
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(16),
        decoration: _containerDecoration(color.withOpacity(0.1)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(subtitle, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewCard(String title, String value, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: _containerDecoration(Colors.white),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 16),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  BoxDecoration _containerDecoration(Color color) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(16),
    );
  }
}
