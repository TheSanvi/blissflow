import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SleepScreen extends StatefulWidget {
  const SleepScreen({Key? key}) : super(key: key);

  @override
  _SleepScreenState createState() => _SleepScreenState();
}

class _SleepScreenState extends State<SleepScreen> {
  TimeOfDay sleepTime = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay wakeTime = const TimeOfDay(hour: 6, minute: 30);

  List<SleepData> pastSleepData = [
    SleepData("Mon", 7),
    SleepData("Tue", 6),
    SleepData("Wed", 8),
    SleepData("Thu", 5),
    SleepData("Fri", 7),
    SleepData("Sat", 6),
    SleepData("Sun", 7),
  ];

  Future<void> _selectTime(BuildContext context, bool isSleepTime) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: isSleepTime ? sleepTime : wakeTime,
    );

    if (pickedTime != null) {
      setState(() {
        if (isSleepTime) {
          sleepTime = pickedTime;
        } else {
          wakeTime = pickedTime;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF3E1E68), Color(0xFF1B1B2F)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Sleep Tracker", style: GoogleFonts.poppins(
                    fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 20),
                _buildTimeCard("Sleep Time", sleepTime, () => _selectTime(context, true)),
                const SizedBox(height: 20),
                _buildTimeCard("Wake Time", wakeTime, () => _selectTime(context, false)),
                const SizedBox(height: 20),
                _buildSleepDuration(),
                const SizedBox(height: 20),
                _buildSleepChart(),
                const SizedBox(height: 20),
                _buildAchievementSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeCard(String title, TimeOfDay time, VoidCallback onTap) {
    return Card(
      color: Colors.white.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(title, style: GoogleFonts.poppins(fontSize: 18, color: Colors.white)),
        trailing: GestureDetector(
          onTap: onTap,
          child: Text("${time.hour}:${time.minute.toString().padLeft(2, '0')}",
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
        ),
      ),
    );
  }

  Widget _buildSleepDuration() {
    int totalSleepHours = wakeTime.hour - sleepTime.hour;
    int totalSleepMinutes = wakeTime.minute - sleepTime.minute;
    if (totalSleepMinutes < 0) {
      totalSleepHours -= 1;
      totalSleepMinutes += 60;
    }
    if (totalSleepHours < 0) {
      totalSleepHours += 24;
    }

    return Column(
      children: [
        Text("$totalSleepHours hrs $totalSleepMinutes mins", style: GoogleFonts.poppins(
            fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
        Text("Total Sleep Duration", style: GoogleFonts.poppins(fontSize: 16, color: Colors.white70)),
      ],
    );
  }

  Widget _buildSleepChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Weekly Sleep Data", style: GoogleFonts.poppins(fontSize: 16, color: Colors.white)),
        const SizedBox(height: 10),
        Container(
          height: 200,
          child: SfCartesianChart(
            backgroundColor: Colors.white.withOpacity(0.2),
            primaryXAxis: CategoryAxis(
              labelStyle: GoogleFonts.poppins(color: Colors.white),
              axisLine: const AxisLine(color: Colors.white),
              majorGridLines: const MajorGridLines(width: 0),
            ),
            primaryYAxis: NumericAxis(
              labelStyle: GoogleFonts.poppins(color: Colors.white),
              axisLine: const AxisLine(color: Colors.white),
              majorGridLines: const MajorGridLines(width: 0.5, color: Colors.white24),
              minimum: 4,
              maximum: 10,
            ),
            series: <CartesianSeries<SleepData, String>>[  // ✅ Fixed Here
              ColumnSeries<SleepData, String>(
                dataSource: pastSleepData,
                xValueMapper: (SleepData data, _) => data.day,
                yValueMapper: (SleepData data, _) => data.hours,
                borderRadius: BorderRadius.circular(6),
                color: Colors.blueAccent,
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  textStyle: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAchievementSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Achievements", style: GoogleFonts.poppins(fontSize: 16, color: Colors.white)),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: ["Early Sleeper", "7-Day Streak", "8+ Hours Club"].map((achievement) {
            return Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12)),
              child: Text(achievement,
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.white)),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class SleepData {
  final String day;
  final int hours;
  SleepData(this.day, this.hours);
}
