import 'package:flutter/material.dart';

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
        title: const Text(
          'Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(),
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
  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Environment Overview / Sensors Activity',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 6),
        Text(
          'Real-time metrics from active locations',
          style: TextStyle(color: Colors.white70),
        ),
      ],
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
      padding: const EdgeInsets.all(20),
      decoration: _card(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Environmental Trends',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          SizedBox(
            height: 180,
            child: Center(
              child: Text(
                '📈 Line Chart (Mock)',
                style: TextStyle(color: Colors.white54),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= PRIORITY ALERTS =================
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
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () =>
                    Navigator.pushNamed(context, '/alerts'),
                child: const Text('View All'),
              )
            ],
          ),
          const Divider(color: Colors.white12),
          _alertRow(
            sensor: 'Storage Temp (Critical)',
            value: '42.8°C',
            color: Colors.red,
            status: 'CRITICAL',
          ),
          _alertRow(
            sensor: 'Freezer A2 Humidity',
            value: '78.2%',
            color: Colors.orange,
            status: 'WARNING',
          ),
        ],
      ),
    );
  }

  Widget _alertRow({
    required String sensor,
    required String value,
    required String status,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              sensor,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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

  // ================= DRAWER =================
  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF0E0E0E),
      child: ListView(
        children: [
          const DrawerHeader(
            child: Text(
              'SMART STORE\nIoT Monitoring',
              style: TextStyle(color: Colors.white),
            ),
          ),
          _drawerItem(context, 'Dashboard', '/dashboard'),
          _drawerItem(context, 'Sites', '/sites'),
          _drawerItem(context, 'Hubs', '/hubs'),
          _drawerItem(context, 'Sensors', '/sensors'),
          _drawerItem(context, 'Alerts', '/alerts'),
        ],
      ),
    );
  }

  ListTile _drawerItem(
      BuildContext context, String title, String route) {
    return ListTile(
      title:
          Text(title, style: const TextStyle(color: Colors.white)),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, route);
      },
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
          Text(title,
              style: const TextStyle(
                  color: Colors.white70, fontSize: 12)),
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
