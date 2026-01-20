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

    // TODO: gọi API dashboard
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
      backgroundColor: const Color(0xFF0E0E0E),
      appBar: _buildAppBar(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderActions(),
                  const SizedBox(height: 16),

                  _buildStatCard(
                    title: 'TOTAL SITES',
                    value: '24',
                    icon: Icons.store,
                  ),
                  const SizedBox(height: 12),

                  _buildStatCard(
                    title: 'ACTIVE ALERTS',
                    value: '03',
                    icon: Icons.warning,
                    valueColor: Colors.red,
                  ),
                  const SizedBox(height: 12),

                  _buildStatCard(
                    title: 'HUBS ONLINE',
                    value: '18 / 20',
                    icon: Icons.router,
                    valueColor: Colors.lightBlueAccent,
                  ),
                  const SizedBox(height: 12),

                  _buildStatCard(
                    title: 'TOTAL SENSORS',
                    value: '142',
                    icon: Icons.sensors,
                  ),

                  const SizedBox(height: 24),

                  // 🔽 THÊM PHẦN CÒN THIẾU
                  _buildEnvironmentalTrends(),
                  const SizedBox(height: 24),
                  _buildPriorityAlerts(),
                ],
              ),
            ),
    );
  }

  // ================= APP BAR =================

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF141414),
      elevation: 0,
      title: Row(
        children: const [
          CircleAvatar(
            radius: 14,
            child: Icon(Icons.person, size: 16),
          ),
          SizedBox(width: 8),
          Text('Alexander Pierce', style: TextStyle(fontSize: 14)),
        ],
      ),
      actions: [
        TextButton.icon(
          onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
              '/login',
              (route) => false,
            );
          },
          icon: const Icon(Icons.logout, color: Colors.white, size: 18),
          label: const Text('LOGOUT', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  // ================= HEADER =================

  Widget _buildHeaderActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'System Status',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Real-time metrics from all active locations',
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 12),

        Row(
          children: [
            ElevatedButton.icon(
              onPressed: _exportData,
              icon: const Icon(Icons.download),
              label: const Text('Export'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2C2C2C),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: _refreshData,
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh'),
            ),
          ],
        ),
      ],
    );
  }

  // ================= STAT CARD =================

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    Color valueColor = Colors.white,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: TextStyle(
                    color: valueColor,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Icon(icon, color: valueColor, size: 28),
        ],
      ),
    );
  }

  // ================= ENVIRONMENTAL TRENDS =================

  Widget _buildEnvironmentalTrends() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Environmental Trends',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: const [
              Text('Temperature', style: TextStyle(color: Colors.white)),
              Spacer(),
              Text('Last 7 Days', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),

        const SizedBox(height: 12),

        Container(
          height: 180,
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Text(
              'Chart Placeholder',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }

  // ================= PRIORITY ALERTS =================

  Widget _buildPriorityAlerts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Priority Sensor Alerts',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {},
              child: const Text('View All History'),
            ),
          ],
        ),
        const SizedBox(height: 12),

        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _alertHeader(),
              const Divider(color: Colors.grey),
              _alertRow(
                name: 'Storage Temp (Critical)',
                location: 'Basement Machine',
                value: '42.8 °C',
                status: 'CRITICAL',
                time: 'Just now',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _alertHeader() {
    return Row(
      children: const [
        Expanded(child: Text('SENSOR NAME', style: TextStyle(color: Colors.grey, fontSize: 12))),
        Expanded(child: Text('VALUE', style: TextStyle(color: Colors.grey, fontSize: 12))),
        Expanded(child: Text('STATUS', style: TextStyle(color: Colors.grey, fontSize: 12))),
        Expanded(child: Text('UPDATE', style: TextStyle(color: Colors.grey, fontSize: 12))),
      ],
    );
  }

  Widget _alertRow({
    required String name,
    required String location,
    required String value,
    required String status,
    required String time,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(color: Colors.white)),
              Text(location, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ),
        Expanded(child: Text(value, style: const TextStyle(color: Colors.red))),
        Expanded(child: Text(status, style: const TextStyle(color: Colors.red))),
        Expanded(child: Text(time, style: const TextStyle(color: Colors.grey))),
      ],
    );
  }
}
