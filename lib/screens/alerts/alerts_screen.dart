import 'package:flutter/material.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  Color _severityColor(String level) {
    switch (level) {
      case 'Critical':
        return Colors.red;
      case 'Warning':
        return Colors.amber;
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    final alerts = [
      {
        'time': '2024-05-14 14:22:05',
        'sensor': 'Freezer Unit A2',
        'severity': 'Critical',
        'value': '-2.4°C',
      },
      {
        'time': '2024-05-14 11:10:45',
        'sensor': 'Water Leak Zone B',
        'severity': 'Critical',
        'value': 'DETECTED',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'IoT Alert History',
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
                      'IoT Alert History Log',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'System-wide critical and warning events.',
                      style: TextStyle(
                          color: Colors.white60,
                          fontSize: 10,
                          letterSpacing: 1),
                    ),
                  ],
                ),
                Row(
                  children: [
                    OutlinedButton(
                      onPressed: () {},
                      child: const Text(
                        'FILTER',
                        style: TextStyle(fontSize: 10),
                      ),
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
                        style: TextStyle(fontSize: 10),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 24),

            /// Table header
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                border: Border.all(color: Colors.white12),
              ),
              child: const Row(
                children: [
                  Expanded(flex: 3, child: Text('TIME')),
                  Expanded(flex: 3, child: Text('SENSOR')),
                  Expanded(flex: 2, child: Text('SEVERITY')),
                  Expanded(flex: 2, child: Text('VALUE')),
                ],
              ),
            ),

            /// Rows
            Expanded(
              child: ListView.separated(
                itemCount: alerts.length,
                separatorBuilder: (_, __) =>
                    Divider(color: Colors.white12, height: 1),
                itemBuilder: (_, index) {
                  final a = alerts[index];
                  final color = _severityColor(a['severity']!);

                  return Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            a['time']!,
                            style:
                                const TextStyle(fontSize: 12),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            a['sensor']!,
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.1),
                              border: Border.all(color: color),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              a['severity']!.toUpperCase(),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: color,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            a['value']!,
                            style: TextStyle(
                              fontSize: 14,
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
