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
      builder: (_) => AddHubDialog(
        onSubmit: (hub) {
          setState(() => hubs.add(hub));
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
          'Hubs Management',
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
                        'Hubs Management',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Configure and monitor gateway devices.',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _openAddHubDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('ADD HUB'),
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
                itemCount: hubs.length,
                itemBuilder: (context, index) {
                  final hub = hubs[index];
                  final bool online = hub['online'];

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
                            color: online
                                ? Colors.green.withOpacity(0.15)
                                : Colors.red.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.router,
                            color:
                                online ? Colors.greenAccent : Colors.redAccent,
                          ),
                        ),
                        const SizedBox(width: 14),

                        /// INFO
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                hub['hubId'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                hub['site'],
                                style:
                                    const TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        ),

                        /// STATUS
                        Row(
                          children: [
                            Icon(
                              Icons.circle,
                              size: 10,
                              color: online ? Colors.green : Colors.red,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              online ? 'ONLINE' : 'OFFLINE',
                              style: TextStyle(
                                color: online
                                    ? Colors.green
                                    : Colors.redAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(width: 8),

                        /// MORE
                        const Icon(Icons.more_vert, color: Colors.white38),
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
