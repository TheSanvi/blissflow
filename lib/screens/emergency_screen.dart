import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({Key? key}) : super(key: key);

  // 📞 Call Function
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri url = Uri.parse("tel:$phoneNumber");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      debugPrint("Could not launch $phoneNumber");
    }
  }

  // 📍 Open Google Maps for Nearby Services
  Future<void> _openGoogleMaps(String query) async {
    final Uri url = Uri.parse("https://www.google.com/maps/search/?api=1&query=$query");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      debugPrint("Could not open Google Maps");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Emergency"),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔴 SOS Button
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () => _makePhoneCall("112"), // Universal emergency number
                child: const Text(
                  "Send SOS Alert",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 📞 Emergency Contacts
            _buildSectionTitle("Emergency Contacts"),

            _buildContactTile("Suicide Prevention", "1800-123-4567"), // Example helpline

            const SizedBox(height: 24),

            // ⚡ Quick Actions
            _buildSectionTitle("Quick Actions"),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildActionCard(Icons.local_hospital, "Find Nearby Hospitals", () {
                  _openGoogleMaps("hospitals near me");
                }),
                _buildActionCard(Icons.local_police, "Find Nearby Police Stations", () {
                  _openGoogleMaps("police stations near me");
                }),
                _buildActionCard(Icons.directions_car, "Call an Ambulance", () {
                  _makePhoneCall("102"); // India ambulance number
                }),
                _buildActionCard(Icons.shield, "Report an Incident", () {
                  _makePhoneCall("100"); // India police emergency
                }),
              ],
            ),

            const SizedBox(height: 24),

            // 🧘 Anxiety Relief
            _buildSectionTitle("Calm Your Mind"),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildActionCard(Icons.self_improvement, "Deep Breathing Exercise", () {
                  // Future: Open a breathing exercise screen
                }),

                _buildActionCard(Icons.psychology, "Stress Relief Tips", () {
                  // Future: Open a stress relief tips screen
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 📌 Section Title Widget
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  // 📞 Emergency Contact Tile
  Widget _buildContactTile(String name, String phone) {
    return ListTile(
      leading: const Icon(Icons.phone, color: Colors.red),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(phone),
      trailing: const Icon(Icons.call, color: Colors.green),
      onTap: () => _makePhoneCall(phone),
    );
  }

  // 🎯 Quick Action Card
  Widget _buildActionCard(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 3)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: Colors.red),
            const SizedBox(height: 8),
            Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
