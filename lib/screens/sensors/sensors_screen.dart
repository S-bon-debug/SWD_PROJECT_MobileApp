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
        return Colors.red;
      case 'Warning':
        return Colors.amber;
      default:
        return Colors.green;
    }
  }

  void _openAddSensor() {
    showDialog(
      context: context,
      builder: (_) => AddSensorDialog(
        onSubmit: (sensor) {
          setState(() {
            sensors.add(sensor);
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'IoT Sensors Management',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'IoT Sensors Management',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Detailed inventory and real-time status.',
                      style: TextStyle(color: Colors.white60),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: _openAddSensor,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text(
                    'REGISTER SENSOR',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            /// Table Header
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                border: Border.all(color: Colors.white12),
              ),
              child: const Row(
                children: [
                  Expanded(flex: 4, child: Text('SENSOR NAME')),
                  Expanded(flex: 3, child: Text('SITE')),
                  Expanded(flex: 3, child: Text('VALUE')),
                  Expanded(flex: 2, child: Text('STATUS')),
                ],
              ),
            ),

            /// Rows
            Expanded(
              child: ListView.separated(
                itemCount: sensors.length,
                separatorBuilder: (_, __) =>
                    Divider(color: Colors.white12, height: 1),
                itemBuilder: (_, index) {
                  final s = sensors[index];
                  final color = _statusColor(s['status']);

                  return Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 16),
                    color: Colors.white.withOpacity(0.03),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: Text(
                            s['name'],
                            style:
                                const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            s['site'],
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            s['value'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                          ),
                        ),
                        
                        Expanded(
                          flex: 2,
                          child: Text(
                            s['status'],
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                          ),
                        ),
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
}
