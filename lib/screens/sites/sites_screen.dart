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
      'id': 'S-CG-002',
      'name': 'WinMart Trung Kính',
      'address': '456 Trung Kính, Hà Nội',
    },
    {
      'id': 'S-CG-003',
      'name': 'WinMart Mỹ Đình',
      'address': '789 Mỹ Đình, Hà Nội',
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
      backgroundColor: const Color(0xFF0A0A0A),

      /// ===== DRAWER (GIỐNG DASHBOARD) =====
      drawer: _buildDrawer(context),

      /// ===== APP BAR =====
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E0E0E),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Sites',
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
            _sitesList(),
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
                'IoT Sites',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Manage environmental monitoring locations.',
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
        ElevatedButton.icon(
          onPressed: _openAddSiteDialog,
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Add Site'),
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

  // ================= SITES LIST =================
  Widget _sitesList() {
    return Column(
      children: sites.map((site) {
        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: _card(),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            leading: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.store,
                color: Colors.blueAccent,
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
                const SizedBox(height: 2),
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
            _menuItem(context, Icons.store, 'Sites', '/sites', active: true),
            _menuItem(context, Icons.router, 'Hubs', '/hubs'),
            _menuItem(context, Icons.sensors, 'Sensors', '/sensors'),
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
