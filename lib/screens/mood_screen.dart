import 'package:flutter/material.dart';

class MoodScreen extends StatefulWidget {
  const MoodScreen({Key? key}) : super(key: key);

  @override
  _MoodScreenState createState() => _MoodScreenState();
}

class _MoodScreenState extends State<MoodScreen> {
  String? selectedMood;
  double anxietyLevel = 0.3;
  List<String> selectedFactors = [];
  List<Map<String, dynamic>> moodHistory = [];

  void saveMoodEntry() {
    if (selectedMood == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a mood')),
      );
      return;
    }

    setState(() {
      moodHistory.add({
        'mood': selectedMood,
        'anxiety': anxietyLevel,
        'factors': List.from(selectedFactors),
        'timestamp': DateTime.now(),
      });

      selectedMood = null;
      anxietyLevel = 0.3;
      selectedFactors.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mood entry saved!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'How are you feeling?',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text('Track your mood and anxiety', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                const SizedBox(height: 24),

                // Mood Selection
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildMoodButton('Happy', Colors.yellow),
                    _buildMoodButton('Calm', Colors.green),
                    _buildMoodButton('Neutral', Colors.grey),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildMoodButton('Sad', Colors.blue),
                    _buildMoodButton('Anxious', Colors.orange),
                    _buildMoodButton('Angry', Colors.red),
                  ],
                ),
                const SizedBox(height: 32),

                // Anxiety Level Slider
                const Text('Anxiety Level', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Slider(
                  value: anxietyLevel,
                  min: 0,
                  max: 1,
                  divisions: 10,
                  onChanged: (value) {
                    setState(() {
                      anxietyLevel = value;
                    });
                  },
                ),
                const SizedBox(height: 32),

                // Mood History
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Mood History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    TextButton(onPressed: () {}, child: const Text('Week')),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 150,
                  child: ListView.builder(
                    itemCount: moodHistory.length,
                    itemBuilder: (context, index) {
                      final entry = moodHistory[index];
                      return ListTile(
                        title: Text('Mood: ${entry['mood']}'),
                        subtitle: Text('Anxiety: ${(entry['anxiety'] * 10).toInt()} / 10\nFactors: ${entry['factors'].join(", ")}'),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 32),

                // Mood Factors
                const Text('What\'s affecting your mood?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: ['Work', 'Family', 'Health', 'Social', 'Sleep']
                      .map((factor) => _buildFactorChip(factor))
                      .toList(),
                ),
                const SizedBox(height: 32),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: saveMoodEntry,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Save Entry'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMoodButton(String label, Color color) {
    bool isSelected = selectedMood == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMood = label;
        });
      },
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: isSelected ? color.withOpacity(0.6) : color.withOpacity(0.2),
              shape: BoxShape.circle,
              border: isSelected ? Border.all(color: color, width: 3) : null,
            ),
            child: Icon(Icons.sentiment_satisfied_alt, color: color, size: 30),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildFactorChip(String label) {
    bool isSelected = selectedFactors.contains(label);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedFactors.remove(label);
          } else {
            selectedFactors.add(label);
          }
        });
      },
      child: Chip(
        label: Text(label),
        backgroundColor: isSelected ? Colors.blue[100] : Colors.grey[200],
      ),
    );
  }
}
