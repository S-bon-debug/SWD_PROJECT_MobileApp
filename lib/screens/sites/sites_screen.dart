import 'package:flutter/material.dart';
import 'add_site_dialog.dart';

class SitesScreen extends StatefulWidget {
  const SitesScreen({super.key});

  @override
  State<SitesScreen> createState() => _SitesScreenState();
}

class _SitesScreenState extends State<SitesScreen> {
  final List<Map<String, String>> sites = [
    {
      'id': 'S-CG-001',
      'name': 'WinMart Cầu Giấy',
      'address': '123 Xuân Thủy, Hà Nội',
    },
    {
      'id': 'S-1769762020618',
      'name': 'a',
      'address': 'a',
    },
    {
      'id': 'S-1769762040698',
      'name': 'ab',
      'address': 'cd',
    },
  ];

  void _openAddSiteDialog() {
    showDialog(
      context: context,
      builder: (_) => AddSiteDialog(
        onSubmit: (site) {
          setState(() => sites.add(site));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0B),

      /// ===== APP BAR =====
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'IoT Sites Management',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      /// ✅ DRAWER – CHUYỂN HƯỚNG THẬT
      drawer: _buildDrawer(context),

      /// ===== BODY =====
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sites',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: ListView.builder(
                itemCount: sites.length,
                itemBuilder: (context, index) {
                  final site = sites[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      leading: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.teal.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.tealAccent,
                        ),
                      ),
                      title: Text(
                        site['name']!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            site['address']!,
                            style: const TextStyle(color: Colors.white70),
                          ),
                          Text(
                            site['id']!,
                            style: const TextStyle(
                              color: Colors.white38,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      trailing: const Icon(
                        Icons.chevron_right,
                        color: Colors.white38,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      /// ===== FAB =====
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddSiteDialog,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        icon: const Icon(Icons.add),
        label: const Text(
          'Add Site',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // ================= DRAWER =================

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF0E0E0E),
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFF141414)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                CircleAvatar(radius: 22, child: Icon(Icons.person)),
                SizedBox(height: 12),
                Text(
                  'SMART STORE',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                Text(
                  'IoT Monitoring',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),

          _drawerItem(Icons.dashboard, 'Dashboard', '/dashboard'),
          _drawerItem(Icons.store, 'Sites', '/sites', active: true),
          _drawerItem(Icons.router, 'Hubs', '/hubs'),
          _drawerItem(Icons.sensors, 'Sensors', '/sensors'),
          _drawerItem(Icons.warning, 'Alerts', '/alerts'),

          const Spacer(),

          _drawerItem(Icons.logout, 'Logout', '/login'),
        ],
      ),
    );
  }

  Widget _drawerItem(
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
        Navigator.pop(context); // đóng drawer
        if (!active) {
          Navigator.pushReplacementNamed(context, route);
        }
      },
    );
  }
}
