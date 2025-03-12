import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String username = "Your Name";
  String age = "Your Age";
  String bio = "Write something about yourself...";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('user_name') ?? "Your Name";
      age = prefs.getInt('user_age')?.toString() ?? "Your Age";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                // Profile image change functionality
              },
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage("assets/profile_default.png"),
              ),
            ),
            const SizedBox(height: 16),

            // Display Username
            Text(
              username,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            // Display Age
            Text(
              "Age: $age",
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
            ),

            const SizedBox(height: 16),

            // Editable Bio Field
            TextField(
              decoration: InputDecoration(
                labelText: "Bio",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  bio = value;
                });
              },
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Icon(Icons.local_fire_department, color: Colors.red, size: 32),
                    Text("7-Day Streak")
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.emoji_emotions, color: Colors.yellow, size: 32),
                    Text("Mood Insights")
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () {
                // Save profile functionality
              },
              child: const Text("Save Profile"),
            ),
          ],
        ),
      ),
    );
  }
}
