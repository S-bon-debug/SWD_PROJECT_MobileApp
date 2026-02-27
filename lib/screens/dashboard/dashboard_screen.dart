import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../services/dashboard_service.dart';
import '../../widgets/app_drawer.dart';

class DashboardScreen extends StatefulWidget {
  final String? token;

  const DashboardScreen({super.key, this.token});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DashboardService _service = DashboardService();

  Map<String, dynamic>? stats;
  List<dynamic> alerts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    

    if (widget.token == null) {
      // Nếu chưa login → hiển thị số 0
      stats = {
        "total_sites": 0,
        "total_hubs": 0,
        "active_sensors": 0,
        "pending_alerts": 0,
      };
      isLoading = false;
    } else {
      // Nếu có token → load API
      loadDashboard();
    }
    debugPrint("TOKEN: ${widget.token}");
  }

  Future<void> loadDashboard() async {
    try {
      final statsData = await _service.getStats(widget.token!);
      final alertData = await _service.getAlerts(widget.token!);

      setState(() {
        stats = statsData;
        alerts = alertData;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Dashboard error: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
       drawer:  AppDrawer(),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E0E0E),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Dashboard",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'System Status',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),

                  /// ================= STATS =================
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    children: [
                      _StatCard(
                        title: "Total Sites",
                        value:
                            stats?["total_sites"]?.toString() ?? "0",
                      ),
                      _StatCard(
                        title: "Total Hubs",
                        value:
                            stats?["total_hubs"]?.toString() ?? "0",
                      ),
                      _StatCard(
                        title: "Active Sensors",
                        value:
                            stats?["active_sensors"]?.toString() ?? "0",
                      ),
                      _StatCard(
                        title: "Pending Alerts",
                        value:
                            stats?["pending_alerts"]?.toString() ?? "0",
                        color: Colors.redAccent,
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  /// ================= CHART (Fake giữ nguyên) =================
                  Container(
                    height: 200,
                    padding: const EdgeInsets.all(16),
                    decoration: _card(),
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(show: false),
                        titlesData: FlTitlesData(show: false),
                        borderData: FlBorderData(show: false),
                        minY: 0,
                        maxY: 50,
                        lineBarsData: [
                          LineChartBarData(
                            isCurved: true,
                            barWidth: 3,
                            color: Colors.blueAccent,
                            dotData: FlDotData(show: false),
                            spots: const [
                              FlSpot(0, 24),
                              FlSpot(1, 26),
                              FlSpot(2, 23),
                              FlSpot(3, 31),
                              FlSpot(4, 28),
                              FlSpot(5, 36),
                              FlSpot(6, 42),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  /// ================= ALERT LIST =================
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: _card(),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Priority Alerts",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (alerts.isEmpty)
                          const Text(
                            "No alerts",
                            style:
                                TextStyle(color: Colors.white54),
                          )
                        else
                          ...alerts
                              .map((a) => _alertRow(a))
                              .toList(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _alertRow(dynamic alert) {
    final severity = alert["severity"] ?? "Info";

    final color = severity == "Critical"
        ? Colors.red
        : severity == "Warning"
            ? Colors.orange
            : Colors.blue;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              alert["sensorName"] ?? "",
              style:
                  const TextStyle(color: Colors.white),
            ),
          ),
          Text(
            "${alert["value"] ?? ""}${alert["metricUnit"] ?? ""}",
            style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  BoxDecoration _card() => BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(14),
        border:
            Border.all(color: const Color(0xFF262626)),
      );
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(14),
        border:
            Border.all(color: const Color(0xFF262626)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style:
                const TextStyle(color: Colors.white70),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
  
}