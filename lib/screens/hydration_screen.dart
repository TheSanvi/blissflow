import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HydrationScreen extends StatefulWidget {
  @override
  _HydrationScreenState createState() => _HydrationScreenState();
}

class _HydrationScreenState extends State<HydrationScreen> {
  int currentWaterIntake = 1200;
  int goal = 2000;

  List<int> pastDaysData = [1500, 1800, 1200, 2000, 1700];
  final List<String> days = ["Mon", "Tue", "Wed", "Thu", "Fri"];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff80bdff), Color(0xff84cfe1)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Text("BlissFlow",
                    style: GoogleFonts.poppins(
                        fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                SizedBox(height: 20),
                _buildWaterProgress(),
                SizedBox(height: 20),
                _buildWaterButtons(),
                SizedBox(height: 20),
                _buildResetButton(),
                SizedBox(height: 20),
                _buildHistoryChart(),  // Syncfusion Chart ✅
                SizedBox(height: 20),
                _buildAchievementsSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWaterProgress() {
    double percentage = (currentWaterIntake / goal).clamp(0, 1);
    return Column(
      children: [
        Text("$currentWaterIntake ml / $goal ml",
            style: GoogleFonts.poppins(fontSize: 18, color: Colors.white)),
        SizedBox(height: 10),
        Stack(
          children: [
            Container(
              height: 18,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            FractionallySizedBox(
              widthFactor: percentage,
              child: Container(
                height: 18,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.blueAccent, Colors.lightBlue]),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Text("${(percentage * 100).toStringAsFixed(1)}% of daily goal",
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70)),
      ],
    );
  }

  Widget _buildWaterButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [250, 500, 1000].map((amount) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                currentWaterIntake = (currentWaterIntake + amount).clamp(0, goal);
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.3),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text("+ $amount ml", style: GoogleFonts.poppins(fontSize: 14, color: Colors.white)),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildResetButton() {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          currentWaterIntake = 0;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.redAccent.withOpacity(0.8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text("Reset Progress", style: GoogleFonts.poppins(fontSize: 14, color: Colors.white)),
    );
  }

  Widget _buildHistoryChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Past 5 Days", style: GoogleFonts.poppins(fontSize: 16, color: Colors.white)),
        SizedBox(height: 10),
        Container(
          height: 200,
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            primaryYAxis: NumericAxis(),
            series: <CartesianSeries>[
              ColumnSeries<_ChartData, String>(  // ✅ Correct Type Used
                dataSource: _getChartData(),
                xValueMapper: (_ChartData data, _) => data.day,
                yValueMapper: (_ChartData data, _) => data.waterIntake,
                borderRadius: BorderRadius.circular(6),
                color: Colors.lightBlueAccent,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAchievementsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Achievements", style: GoogleFonts.poppins(fontSize: 16, color: Colors.white)),
        SizedBox(height: 10),
        Wrap(
          spacing: 10,
          children: ["Hydration Hero", "Perfect Week", "Early Bird"].map((achievement) {
            return Chip(
              backgroundColor: Colors.white.withOpacity(0.2),
              label: Text(achievement, style: GoogleFonts.poppins(fontSize: 14, color: Colors.white)),
            );
          }).toList(),
        ),
      ],
    );
  }

  List<_ChartData> _getChartData() {
    return List.generate(pastDaysData.length, (index) {
      return _ChartData(days[index], pastDaysData[index]);
    });
  }
}

class _ChartData {
  final String day;
  final int waterIntake;
  _ChartData(this.day, this.waterIntake);
}


