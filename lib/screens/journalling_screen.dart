import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class JournalScreen extends StatefulWidget {
  @override
  _JournalScreenState createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  Database? _database;
  String selectedMood = "Happy";
  int streakCount = 0;
  TextEditingController journalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'journal.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE journal(id INTEGER PRIMARY KEY, mood TEXT, entry TEXT, date TEXT, streak INTEGER)",
        );
      },
      version: 1,
    );
    _loadStreak();
  }

  Future<void> _loadStreak() async {
    final List<Map<String, dynamic>> maps = await _database!.query('journal');
    if (maps.isNotEmpty) {
      setState(() {
        streakCount = maps.last['streak'] ?? 0;
      });
    }
  }

  void _saveJournalEntry(BuildContext context) async {
    if (journalController.text.isEmpty) return;

    await _database!.insert(
      'journal',
      {
        'mood': selectedMood,
        'entry': journalController.text,
        'date': DateTime.now().toString(),
        'streak': streakCount + 1,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    setState(() {
      streakCount++;
    });

    // Use valid BuildContext
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Journal entry saved!", textAlign: TextAlign.center),
          backgroundColor: Colors.pinkAccent,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  String _getReflectionPrompt() {
    switch (selectedMood) {
      case 'Excited':
        return "What are you excited about?";
      case 'Happy':
        return "What made you smile today?";
      case 'Calm':
        return "What brought you peace today?";
      case 'Sad':
        return "What's troubling you today?";
      case 'Stressed':
        return "What's been on your mind lately?";
      default:
        return "How was your day?";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFC1E3), Color(0xFFFF80AB)], // Light Pink to Dark Pink
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'How are you feeling today?',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: ['Excited', 'Happy', 'Calm', 'Sad', 'Stressed']
                      .map((mood) => GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedMood = mood;
                      });
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: selectedMood == mood ? Colors.blue.shade100 : Colors.grey.shade200,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.sentiment_satisfied_alt, size: 24),
                        ),
                        SizedBox(height: 8),
                        Text(mood),
                      ],
                    ),
                  ))
                      .toList(),
                ),
                SizedBox(height: 24),

                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Daily Reflection', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      SizedBox(height: 8),
                      Text(_getReflectionPrompt(), style: TextStyle(color: Colors.grey, fontSize: 14)),
                      TextField(
                        controller: journalController,
                        maxLines: 5,
                        decoration: InputDecoration(border: InputBorder.none),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),

                // Save Entry Button with valid BuildContext
                Center(
                  child: ElevatedButton(
                    onPressed: () => _saveJournalEntry(context), // Pass the correct context
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      backgroundColor: Colors.pinkAccent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 5,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.save, color: Colors.white),
                        SizedBox(width: 8),
                        Text('Save Entry', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
