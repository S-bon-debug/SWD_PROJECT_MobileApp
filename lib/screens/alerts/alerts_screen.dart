import 'package:flutter/material.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  Color _severityColor(String level) {
    switch (level) {
      case 'Critical':
        return Colors.redAccent;
      case 'Warning':
        return Colors.orangeAccent;
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

      /// ===== DRAWER =====
      drawer: _buildDrawer(context),

      /// ===== APP BAR =====
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E0E0E),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Alerts',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      /// ===== BODY =====
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Alert History',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'System anomalies and real-time alerts.',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white38),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Filter'),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.download, size: 16),
                  label: const Text('Export'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            /// TABLE
            _tableHeader(),
            const SizedBox(height: 10),
            ...alerts.map((a) {
              final color = _severityColor(a['severity']!);
              return _alertRow(a, color);
            }).toList(),
          ],
        ),
      ),
    );
  }

  // ================= TABLE HEADER =================

  Widget _tableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: _card(),
      child: const Row(
        children: [
          Expanded(
            flex: 3,
            child: Text('TIME',
                style: TextStyle(color: Colors.white70, fontSize: 11)),
          ),
          Expanded(
            flex: 4,
            child: Text('SENSOR',
                style: TextStyle(color: Colors.white70, fontSize: 11)),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text('SEVERITY',
                  style: TextStyle(color: Colors.white70, fontSize: 11)),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'VALUE',
              textAlign: TextAlign.right,
              style: TextStyle(color: Colors.white70, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  // ================= ALERT ROW =================

  Widget _alertRow(Map<String, String> a, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: _card(),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              a['time']!,
              style: const TextStyle(fontSize: 11, color: Colors.white),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              a['sensor']!,
              style: const TextStyle(color: Colors.white),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: color),
                ),
                child: Text(
                  a['severity']!.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
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
      width: 280,
      backgroundColor: const Color(0xFF0C0C0C),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: const [
                  Icon(Icons.dashboard,
                      color: Colors.blueAccent, size: 32),
                  SizedBox(width: 12),
                  Text(
                    'SMART STORE\nIoT Monitoring',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white12),

            _menuItem(context, Icons.dashboard, 'Dashboard', '/dashboard'),
            _menuItem(context, Icons.store, 'Sites', '/sites'),
            _menuItem(context, Icons.router, 'Hubs', '/hubs'),
            _menuItem(context, Icons.sensors, 'Sensors', '/sensors'),
            _menuItem(context, Icons.warning, 'Alerts', '/alerts',
                active: true),

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
    String route, {
    bool active = false,
  }) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        if (!active) {
          Navigator.pushReplacementNamed(context, route);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: active
            ? BoxDecoration(color: Colors.white.withOpacity(0.05))
            : null,
        child: Row(
          children: [
            Icon(icon,
                color: active ? Colors.white : Colors.white70, size: 20),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                color: active ? Colors.white : Colors.white70,
                fontWeight:
                    active ? FontWeight.bold : FontWeight.normal,
              ),
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
