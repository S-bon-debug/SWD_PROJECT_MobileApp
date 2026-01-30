import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isLoading = false;

  void _refreshData() async {
    setState(() => isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => isLoading = false);
  }

  void _exportData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Export started')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),

      /// 🔥 SIDE MENU
      drawer: _buildDrawer(context),

      appBar: _buildAppBar(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),

                  GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: const [
                      _StatCard(
                        title: 'TOTAL SITES',
                        value: '24',
                        icon: Icons.store,
                      ),
                      _StatCard(
                        title: 'ACTIVE ALERTS',
                        value: '03',
                        icon: Icons.warning,
                        color: Colors.red,
                      ),
                      _StatCard(
                        title: 'HUBS ONLINE',
                        value: '18 / 20',
                        icon: Icons.router,
                        color: Colors.lightBlueAccent,
                      ),
                      _StatCard(
                        title: 'TOTAL SENSORS',
                        value: '142',
                        icon: Icons.sensors,
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),
                  _buildTrends(),
                  const SizedBox(height: 32),
                  _buildPriorityAlerts(),
                ],
              ),
            ),
    );
  }

  // ================= APP BAR =================

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF0E0E0E),
      elevation: 0,
      title: const Text('Dashboard'),
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

  // ================= HEADER =================

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'System Status',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Real-time metrics from active locations',
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _ActionButton(
              icon: Icons.download,
              label: 'Export',
              onTap: _exportData,
              bg: const Color(0xFF1F1F1F),
            ),
            const SizedBox(width: 12),
            _ActionButton(
              icon: Icons.refresh,
              label: 'Refresh',
              onTap: _refreshData,
              bg: Colors.blueAccent,
            ),
          ],
        )
      ],
    );
  }

  Widget _buildTrends() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardStyle(),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Environmental Trends',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: Center(
              child: Text('📈 Line Chart (mock)',
                  style: TextStyle(color: Colors.grey)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPriorityAlerts() {
    return Container(
      decoration: _cardStyle(),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: const [
          Text('Priority Alerts', style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  BoxDecoration _cardStyle() => BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF262626)),
      );
}

// ================= COMPONENTS =================

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF262626)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style:
                      const TextStyle(color: Colors.grey, fontSize: 12)),
              Icon(icon, color: color),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color bg;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.bg,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(backgroundColor: bg),
      icon: Icon(icon, size: 18),
      label: Text(label),
      onPressed: onTap,
    );
  }
}
