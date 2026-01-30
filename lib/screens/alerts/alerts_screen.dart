import 'package:flutter/material.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  Color _severityColor(String level) {
    switch (level) {
      case 'Critical':
        return Colors.redAccent;
      case 'Warning':
        return Colors.amber;
      default:
        return Colors.greenAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final alerts = [
      {
        'time': '2024-05-14\n14:22:05',
        'sensor': 'Freezer Unit A2',
        'severity': 'Critical',
        'value': '-2.4°C',
      },
      {
        'time': '2024-05-14\n11:10:45',
        'sensor': 'Water Leak Zone B',
        'severity': 'Critical',
        'value': 'DETECTED',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),

      /// ===== APP BAR =====
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'IoT Alert History',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      /// ✅ DRAWER – THANH MENU
      drawer: _buildDrawer(context),

      /// ===== BODY =====
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            const Text(
              'IoT Alert History Log',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              'SYSTEM-WIDE CRITICAL AND WARNING EVENTS',
              style: TextStyle(
                color: Colors.white60,
                fontSize: 10,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white24),
                  ),
                  child: const Text('FILTER', style: TextStyle(fontSize: 11)),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text(
                    'EXPORT CSV',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// TABLE HEADER
            _tableHeader(),

            const SizedBox(height: 8),

            /// TABLE BODY
            Expanded(
              child: ListView.separated(
                itemCount: alerts.length,
                separatorBuilder: (_, __) =>
                    const Divider(color: Colors.white12),
                itemBuilder: (_, i) {
                  final a = alerts[i];
                  final color = _severityColor(a['severity']!);

                  return _alertRow(a, color);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= UI PARTS =================

  Widget _tableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white12),
      ),
      child: const Row(
        children: [
          Expanded(flex: 3, child: Text('TIME')),
          Expanded(flex: 4, child: Text('SENSOR')),
          Expanded(flex: 2, child: Text('SEVERITY')),
          Expanded(flex: 2, child: Text('VALUE')),
        ],
      ),
    );
  }

  Widget _alertRow(Map<String, String> a, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(a['time']!,
                style: const TextStyle(fontSize: 11)),
          ),
          Expanded(
            flex: 4,
            child: Text(
              a['sensor']!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: color),
                ),
                child: Text(
                  a['severity']!.toUpperCase(),
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              a['value']!,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
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
      child: Column(
        children: [
          const DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(child: Icon(Icons.person)),
                SizedBox(height: 12),
                Text('SMART STORE',
                    style: TextStyle(color: Colors.white)),
                Text('IoT Monitoring',
                    style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),

          _drawerItem(context, Icons.dashboard, 'Dashboard', '/dashboard'),
          _drawerItem(context, Icons.store, 'Sites', '/sites'),
          _drawerItem(context, Icons.router, 'Hubs', '/hubs'),
          _drawerItem(context, Icons.sensors, 'Sensors', '/sensors'),
          _drawerItem(context, Icons.warning, 'Alerts', '/alerts',
              active: true),

          const Spacer(),

          _drawerItem(context, Icons.logout, 'Logout', '/login'),
        ],
      ),
    );
  }

  Widget _drawerItem(
    BuildContext context,
    IconData icon,
    String title,
    String route, {
    bool active = false,
  }) {
    return ListTile(
      leading: Icon(icon, color: active ? Colors.white : Colors.white54),
      title: Text(
        title,
        style: TextStyle(
          color: active ? Colors.white : Colors.white70,
          fontWeight: active ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        if (!active) {
          Navigator.pushReplacementNamed(context, route);
        }
      },
    );
  }
}
