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
      drawer: _buildDrawer(context),

      /// ===== APP BAR =====
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E0E0E),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Hubs',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      /// ===== BODY =====
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ===== HEADER =====
            Row(
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
                ElevatedButton.icon(
                  onPressed: _openAddHubDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('ADD HUB'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            /// ===== LIST =====
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
                      color: const Color(0xFF141414),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFF262626)),
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
            _menuItem(context, Icons.warning, 'Alerts', '/alerts'),

            const Spacer(),
            const Divider(color: Colors.white12),

            /// LOGOUT
            InkWell(
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
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
            ),
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
}
