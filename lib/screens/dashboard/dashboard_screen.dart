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
  Map<String, dynamic>? environment;
  List<dynamic> alerts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    debugPrint("TOKEN: ${widget.token}");

    if (widget.token == null) {
      stats = {
        "total_sites": 0,
        "total_hubs": 0,
        "active_sensors": 0,
        "active_alerts": 0,
      };
      isLoading = false;
    } else {
      loadDashboard();
    }
  }

  Future<void> loadDashboard() async {
    try {
      final statsData = await _service.getStats(widget.token!);
      final alertData = await _service.getAlerts(widget.token!);
      final envData =
          await _service.getCurrentEnvironment(widget.token!, 1);

      setState(() {
        stats = statsData;
        alerts = alertData;
        environment = envData; 
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
      drawer: AppDrawer(),
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

                  /// ================= STATS =================
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    const Text(
      'System Status',
      style: TextStyle(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    ),

    InkWell(
      onTap: () {
        setState(() {
          isLoading = true;
        });
        loadDashboard();
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF2A2A2A)),
        ),
        child: Row(
          children: const [
            Icon(
              Icons.refresh,
              size: 18,
              color: Colors.white70,
            ),
            SizedBox(width: 6),
            Text(
              "Refresh",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    ),
  ],
),
                  const SizedBox(height: 24),

                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 1.6,
                    children: [
                      _StatCard(
                        title: "Total Sites",
                        value: stats?["total_sites"]?.toString() ?? "0",
                        icon: Icons.location_on,
                        color: Colors.blue,
                      ),
                      _StatCard(
                        title: "Total Hubs",
                        value: stats?["total_hubs"]?.toString() ?? "0",
                        icon: Icons.hub,
                        color: Colors.green,
                      ),
                      _StatCard(
                        title: "Active Sensors",
                        value: stats?["active_sensors"]?.toString() ?? "0",
                        icon: Icons.sensors,
                        color: Colors.orange,
                      ),
                      _StatCard(
                        title: "Alerts Active",
                        value: stats?["active_alerts"]?.toString() ?? "0",
                        icon: Icons.warning,
                        color: Colors.redAccent,
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  /// ================= CURRENT ENVIRONMENT =================
                  if (environment != null) ...[
                    const Text(
                      "Current Environment",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildEnvironmentCards(),
                    const SizedBox(height: 32),
                  ],

                  /// ================= CHART =================
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

                  /// ================= ALERTS =================
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: _card(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                            style: TextStyle(color: Colors.white54),
                          )
                        else
                          ...alerts.map((a) => _alertRow(a)).toList(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  /// ================= ENVIRONMENT CARDS =================
 Widget _buildEnvironmentCards() {
  final sensors = environment?["sensors"] ?? [];

  double temp = 0;
  double humidity = 0;
  double pressure = 0;
  String lastUpdate = "Just now";

  for (var s in sensors) {
    final type = s["typeName"];
    final value =
        s["readings"] != null && s["readings"].isNotEmpty
            ? s["readings"][0]["value"]
            : 0;

    if (type == "Temperature") temp = value.toDouble();
    if (type == "Humidity") humidity = value.toDouble();
    if (type == "Pressure") pressure = value.toDouble();
  }

  return Column(
    children: [
      _environmentCard(
        title: "Temperature",
        value: "$temp °C",
        icon: Icons.thermostat,
        color: Colors.orange,
        subtitle: "Ha Noi Temperature Sensor",
        lastUpdate: lastUpdate,
      ),
      const SizedBox(height: 16),
      _environmentCard(
        title: "Humidity",
        value: "$humidity %",
        icon: Icons.water_drop,
        color: Colors.blue,
        subtitle: "Ha Noi Humidity Sensor",
        lastUpdate: lastUpdate,
      ),
      const SizedBox(height: 16),
      _environmentCard(
        title: "Pressure",
        value: "$pressure hPa",
        icon: Icons.speed,
        color: Colors.purple,
        subtitle: "Ha Noi Pressure Sensor",
        lastUpdate: lastUpdate,
      ),
    ],
  );
}

  Widget _envCard({
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _card(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
Widget _environmentCard({
  required String title,
  required String value,
  required IconData icon,
  required Color color,
  required String subtitle,
  required String lastUpdate,
}) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: const Color(0xFF141414),
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: const Color(0xFF262626)),
    ),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                value,
                style: TextStyle(
                  color: color,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Last update: $lastUpdate",
                style: const TextStyle(
                  color: Colors.white38,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        )
      ],
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
              style: const TextStyle(color: Colors.white),
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
        border: Border.all(color: const Color(0xFF262626)),
      );
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF262626)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}