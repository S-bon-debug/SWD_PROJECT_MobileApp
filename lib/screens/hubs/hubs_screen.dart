import 'package:flutter/material.dart';
import 'add_hub_dialog.dart';

class HubsScreen extends StatefulWidget {
  const HubsScreen({super.key});

  @override
  State<HubsScreen> createState() => _HubsScreenState();
}

class _HubsScreenState extends State<HubsScreen> {
  final List<Map<String, dynamic>> hubs = [
    {
      'hubId': 'HUB-772-AX',
      'site': 'SITE-NORTH-01',
      'online': false,
    },
    {
      'hubId': 'HUB-042-ZW',
      'site': 'SITE-HUB-A2',
      'online': true,
    },
  ];

  void _openAddHubDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AddHubDialog(
        onSubmit: (hub) {
          setState(() {
            hubs.add(hub);
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
          'IoT Hubs Management',
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
                      'Hubs Management',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Configure and monitor gateway devices.',
                      style: TextStyle(color: Colors.white60),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: _openAddHubDialog,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text(
                    'ADD NEW HUB',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
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
                  Expanded(flex: 3, child: Text('HUB ID')),
                  Expanded(flex: 3, child: Text('SITE NAME')),
                  Expanded(flex: 3, child: Text('STATUS')),
                  Expanded(flex: 1, child: SizedBox()),
                ],
              ),
            ),

            /// Rows
            Expanded(
              child: ListView.separated(
                itemCount: hubs.length,
                separatorBuilder: (_, __) =>
                    Divider(color: Colors.white12, height: 1),
                itemBuilder: (_, index) {
                  final hub = hubs[index];
                  final isOnline = hub['online'];

                  return Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 16),
                    color: Colors.white.withOpacity(0.03),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            hub['hubId'],
                            style:
                                const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(hub['site']),
                        ),
                        Expanded(
                          flex: 3,
                          child: Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: isOnline
                                      ? Colors.green
                                      : Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                isOnline ? 'ONLINE' : 'OFFLINE',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: isOnline
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Icon(Icons.more_vert,
                                color: Colors.white54),
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
