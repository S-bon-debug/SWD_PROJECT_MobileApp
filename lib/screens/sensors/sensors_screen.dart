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
      backgroundColor: const Color(0xFF0B0B0B),

      /// ===== MENU =====
      drawer: _buildDrawer(context),

      /// ===== APP BAR =====
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Sensors',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      /// ===== BODY =====
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'IoT Sensors Management',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Detailed inventory and real-time status.',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _openAddSensor,
                  icon: const Icon(Icons.add),
                  label: const Text('REGISTER'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// LIST
            Expanded(
              child: ListView.builder(
                itemCount: sensors.length,
                itemBuilder: (context, index) {
                  final s = sensors[index];
                  final color = _statusColor(s['status']);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.white12),
                    ),
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
                          child: Icon(
                            Icons.sensors,
                            color: color,
                          ),
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
                                style:
                                    const TextStyle(color: Colors.white70),
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
                            const SizedBox(height: 4),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.circle,
                                    size: 8, color: color),
                                const SizedBox(width: 6),
                                Text(
                                  s['status'].toUpperCase(),
                                  style: TextStyle(
                                    color: color,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(width: 8),
                        const Icon(Icons.more_vert,
                            color: Colors.white38),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ===== DRAWER =====
  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF0E0E0E),
      child: Column(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF141414)),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                'SMART STORE\nIoT Monitoring',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          _drawerItem(Icons.dashboard, 'Dashboard', '/dashboard', context),
          _drawerItem(Icons.store, 'Sites', '/sites', context),
          _drawerItem(Icons.router, 'Hubs', '/hubs', context),
          _drawerItem(Icons.sensors, 'Sensors', '/sensors', context),
          _drawerItem(Icons.warning, 'Alerts', '/alerts', context),

          const Spacer(),

          _drawerItem(Icons.logout, 'Logout', '/login', context),
        ],
      ),
    );
  }

  ListTile _drawerItem(
    IconData icon,
    String title,
    String route,
    BuildContext context,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, route);
      },
    );
  }
}
