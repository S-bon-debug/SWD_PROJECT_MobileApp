import 'package:flutter/material.dart';
import 'add_sensor_dialog.dart';

class SensorsScreen extends StatefulWidget {
  const SensorsScreen({super.key});

  @override
  State<SensorsScreen> createState() => _SensorsScreenState();
}

class _SensorsScreenState extends State<SensorsScreen> {
  final List<Map<String, dynamic>> sensors = [
    {
      'name': 'Storage Temp (Critical)',
      'site': 'SITE-NORTH-01',
      'value': '42.8°C',
      'status': 'Critical',
    },
    {
      'name': 'Main Hub CO2',
      'site': 'SITE-HUB-A2',
      'value': '1240 PPM',
      'status': 'Warning',
    },
  ];

  Color _statusColor(String status) {
    switch (status) {
      case 'Critical':
        return Colors.redAccent;
      case 'Warning':
        return Colors.orangeAccent;
      default:
        return Colors.greenAccent;
    }
  }

  void _openAddSensor() {
    showDialog(
      context: context,
      builder: (_) => AddSensorDialog(
        onSubmit: (sensor) {
          setState(() => sensors.add(sensor));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),

      /// ===== DRAWER (GIỐNG DASHBOARD) =====
      drawer: _buildDrawer(context),

      /// ===== APP BAR =====
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E0E0E),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Sensors',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      /// ===== BODY =====
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(),
            const SizedBox(height: 24),
            _sensorList(),
          ],
        ),
      ),
    );
  }

  // ================= HEADER =================
  Widget _header() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'IoT Sensors',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Real-time status of environmental sensors.',
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
        ElevatedButton.icon(
          onPressed: _openAddSensor,
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Register'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }

  // ================= SENSOR LIST =================
  Widget _sensorList() {
    return Column(
      children: sensors.map((s) {
        final color = _statusColor(s['status']);
        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: _card(),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              /// ICON
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.sensors, color: color),
              ),
              const SizedBox(width: 14),

              /// INFO
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s['name'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      s['site'],
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),

              /// VALUE + STATUS
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    s['value'],
                    style: TextStyle(
                      color: color,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: color),
                    ),
                    child: Text(
                      s['status'].toUpperCase(),
                      style: TextStyle(
                        color: color,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 6),
              const Icon(Icons.more_vert, color: Colors.white38),
            ],
          ),
        );
      }).toList(),
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
            _menuItem(context, Icons.sensors, 'Sensors', '/sensors',
                active: true),
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
            ? BoxDecoration(
                color: Colors.white.withOpacity(0.05),
              )
            : null,
        child: Row(
          children: [
            Icon(
              icon,
              color: active ? Colors.white : Colors.white70,
              size: 20,
            ),
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
