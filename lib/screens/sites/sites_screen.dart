// lib/screens/sites/sites_screen.dart
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
    }
  ];

  void _openAddSiteDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AddSiteDialog(
        onSubmit: (site) {
          setState(() {
            sites.add(site);
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
          'IoT Sites Management',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
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
                const Text(
                  'IoT Sites Management',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _openAddSiteDialog,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text(
                    'ADD NEW SITE',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
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
                  Expanded(flex: 2, child: Text('SITE ID')),
                  Expanded(flex: 3, child: Text('NAME')),
                  Expanded(flex: 5, child: Text('ADDRESS')),
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(''),
                    ),
                  ),
                ],
              ),
            ),

            /// Table Rows
            Expanded(
              child: ListView.separated(
                itemCount: sites.length,
                separatorBuilder: (_, __) =>
                    Divider(color: Colors.white12, height: 1),
                itemBuilder: (context, index) {
                  final site = sites[index];
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.03),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            site['id']!,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(site['name']!),
                        ),
                        Expanded(
                          flex: 5,
                          child: Text(
                            site['address']!,
                            style:
                                const TextStyle(color: Colors.white70),
                          ),
                        ),
                        const Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Icon(
                              Icons.edit,
                              size: 18,
                              color: Colors.white54,
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
