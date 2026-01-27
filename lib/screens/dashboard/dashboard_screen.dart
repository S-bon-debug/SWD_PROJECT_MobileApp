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

                  /// STAT GRID
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
      title: Row(
        children: const [
          CircleAvatar(radius: 14, child: Icon(Icons.person, size: 16)),
          SizedBox(width: 8),
          Text('Alexander Pierce', style: TextStyle(fontSize: 14)),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
              '/login',
              (_) => false,
            );
          },
        )
      ],
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

  // ================= TRENDS =================

  Widget _buildTrends() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardStyle(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Environmental Trends',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: Center(
              child: Text(
                '📈 Line Chart (mock)',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          )
        ],
      ),
    );
  }

  // ================= ALERTS =================

  Widget _buildPriorityAlerts() {
    return Container(
      decoration: _cardStyle(),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey)),
            ),
            child: Row(
              children: const [
                Expanded(child: Text('Sensor', style: _thStyle)),
                Expanded(child: Text('Value', style: _thStyle)),
                Expanded(child: Text('Status', style: _thStyle)),
              ],
            ),
          ),
          _alertRow(
            'Storage Temp',
            '42.8°C',
            'CRITICAL',
            Colors.red,
          ),
          _alertRow(
            'Freezer A2 Humidity',
            '78.2%',
            'WARNING',
            Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _alertRow(
    String name,
    String value,
    String status,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
              child: Text(name, style: const TextStyle(color: Colors.white))),
          Expanded(
              child: Text(value,
                  style: TextStyle(color: color, fontWeight: FontWeight.bold))),
          Expanded(
              child: Text(status,
                  style: TextStyle(
                      color: color, fontWeight: FontWeight.bold))),
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

const _thStyle = TextStyle(
  color: Colors.grey,
  fontSize: 12,
  fontWeight: FontWeight.bold,
);
