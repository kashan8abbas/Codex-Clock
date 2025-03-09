import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

Widget _buildChartSection() {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    color: Colors.white, // Light background
    elevation: 5,
    shadowColor: Colors.black.withOpacity(0.1),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Tab Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _ChartTab(text: "Weekly", isSelected: true),
              _ChartTab(text: "Monthly", isSelected: false),
              _ChartTab(text: "Yearly", isSelected: false),
            ],
          ),
          const SizedBox(height: 10),

          // Bar Chart
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                gridData: FlGridData(show: true, drawHorizontalLine: true),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        List<String> days = [
                          "Mon",
                          "Tue",
                          "Wed",
                          "Thu",
                          "Fri",
                          "Sat",
                          "Sun",
                        ];
                        return Text(
                          days[value.toInt()],
                          style: const TextStyle(fontSize: 12),
                        );
                      },
                    ),
                  ),
                ),
                barGroups: [
                  _buildBarGroup(0, 120, Colors.red), // Mon
                  _buildBarGroup(1, 110, Colors.pink.shade300), // Tue
                  _buildBarGroup(2, 140, Colors.red), // Wed
                  _buildBarGroup(3, 100, Colors.pink.shade300), // Thu
                  _buildBarGroup(4, 130, Colors.red), // Fri
                  _buildBarGroup(5, 50, Colors.pink.shade300), // Sat
                  _buildBarGroup(6, 60, Colors.pink.shade300), // Sun
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

// Helper for bar groups
BarChartGroupData _buildBarGroup(int x, double y, Color color) {
  return BarChartGroupData(
    x: x,
    barRods: [
      BarChartRodData(
        toY: y,
        color: color,
        width: 15,
        borderRadius: BorderRadius.circular(5),
      ),
    ],
  );
}

// Chart Tab Widget
class _ChartTab extends StatelessWidget {
  final String text;
  final bool isSelected;

  const _ChartTab({required this.text, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: Colors.black87,
        ),
      ),
    );
  }
}
