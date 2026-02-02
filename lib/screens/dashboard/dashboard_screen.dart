import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      drawer: _buildDrawer(context),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E0E0E),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Dashboard',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(context),
            const SizedBox(height: 24),
            _statsGrid(),
            const SizedBox(height: 32),
            _environmentChart(),
            const SizedBox(height: 32),
            _priorityAlerts(context),
          ],
        ),
      ),
    );
  }

  // ================= HEADER =================
  Widget _header(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'System Status',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Real-time metrics from 24 active locations.',
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
        Column(
          children: [
            _headerButton(
              context,
              Icons.refresh,
              'Refresh',
              Colors.blueAccent,
            ),
            const SizedBox(height: 8),
            _headerButton(
              context,
              Icons.download,
              'Export',
              const Color(0xFF1F1F1F),
            ),
          ],
        ),
      ],
    );
  }

  Widget _headerButton(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
  ) {
    return SizedBox(
      height: 42,
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: Icon(icon, size: 18),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  // ================= STATS =================
  Widget _statsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: const [
        _StatCard(title: 'TOTAL SITES', value: '24'),
        _StatCard(title: 'ACTIVE ALERTS', value: '03', color: Colors.red),
        _StatCard(title: 'HUBS ONLINE', value: '18 / 20', color: Colors.blue),
        _StatCard(title: 'TOTAL SENSORS', value: '142'),
      ],
    );
  }

  // ================= CHART =================
  Widget _environmentChart() {
    return Container(
      decoration: _card(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Environmental Trends',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 180,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                minY: 20,
                maxY: 45,
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    barWidth: 3,
                    color: Colors.blueAccent,
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.blueAccent.withOpacity(0.15),
                    ),
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
        ],
      ),
    );
  }

  // ================= ALERTS =================
  Widget _priorityAlerts(BuildContext context) {
    return Container(
      decoration: _card(),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                'Priority Alerts',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/alerts'),
                child: const Text('View All'),
              ),
            ],
          ),
          const Divider(color: Colors.white12),
          _alertRow('Storage Temp (Critical)', '42.8°C', 'CRITICAL', Colors.red),
          _alertRow(
              'Freezer A2 Humidity', '78.2%', 'WARNING', Colors.orange),
        ],
      ),
    );
  }

  Widget _alertRow(
    String sensor,
    String value,
    String status,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(sensor, style: const TextStyle(color: Colors.white)),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: color),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= DRAWER (WEB STYLE) =================
  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      width: 280,
      backgroundColor: const Color(0xFF0C0C0C),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: const [
                  Icon(Icons.dashboard, color: Colors.blueAccent, size: 32),
                  SizedBox(width: 12),
                  Text(
                    'SMART STORE\nIoT Monitoring',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white12),
            _menuItem(context, Icons.dashboard, 'Dashboard', '/dashboard'),
            _menuItem(context, Icons.store, 'Sites', '/sites'),
            _menuItem(context, Icons.router, 'Hubs', '/hubs'),
            _menuItem(context, Icons.sensors, 'Sensors', '/sensors'),
            _menuItem(context, Icons.warning, 'Alerts', '/alerts'),
            const Spacer(),
            const Divider(color: Colors.white12),
            _logoutItem(context),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _menuItem(
    BuildContext context,
    IconData icon,
    String title,
    String route,
  ) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, route);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: Colors.white70, size: 20),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _logoutItem(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, '/login');
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: const [
            Icon(Icons.logout, color: Colors.redAccent),
            SizedBox(width: 16),
            Text(
              'Logout',
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _card() => BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF262626)),
      );
}

// ================= STAT CARD =================
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
        border: Border.all(color: const Color(0xFF262626)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white70)),
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
