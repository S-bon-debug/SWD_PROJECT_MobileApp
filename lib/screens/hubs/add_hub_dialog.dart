import 'package:flutter/material.dart';

class AddHubDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onSubmit;

  const AddHubDialog({super.key, required this.onSubmit});

  @override
  State<AddHubDialog> createState() => _AddHubDialogState();
}

class _AddHubDialogState extends State<AddHubDialog> {
  String selectedSite = 'SITE-NORTH-01';
  final TextEditingController hubNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF0A0A0A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.white12),
      ),
      child: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'ADD NEW HUB',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, letterSpacing: 1),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Divider(color: Colors.white12),

            /// Form
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'SITE SELECTION',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70),
                  ),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    value: selectedSite,
                    items: const [
                      DropdownMenuItem(
                          value: 'SITE-NORTH-01',
                          child: Text('SITE-NORTH-01')),
                      DropdownMenuItem(
                          value: 'SITE-MAIN-04',
                          child: Text('SITE-MAIN-04')),
                    ],
                    onChanged: (v) => setState(() => selectedSite = v!),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'HUB NAME',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: hubNameController,
                    decoration: const InputDecoration(
                      hintText: 'e.g. HUB-NEW-GEN',
                    ),
                  ),
                ],
              ),
            ),

            Divider(color: Colors.white12),

            /// Actions
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('CANCEL'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        widget.onSubmit({
                          'hubId': hubNameController.text,
                          'site': selectedSite,
                          'online': false,
                        });
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                      ),
                      child: const Text(
                        'REGISTER HUB',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
