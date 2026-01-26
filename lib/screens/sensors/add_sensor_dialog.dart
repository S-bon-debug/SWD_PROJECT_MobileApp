import 'package:flutter/material.dart';

class AddSensorDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onSubmit;

  const AddSensorDialog({super.key, required this.onSubmit});

  @override
  State<AddSensorDialog> createState() => _AddSensorDialogState();
}

class _AddSensorDialogState extends State<AddSensorDialog> {
  final TextEditingController nameCtrl = TextEditingController();
  String selectedHub = 'HUB-NORTH-X1';
  String selectedType = 'Temperature';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'REGISTER SENSOR',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameCtrl,
              decoration:
                  const InputDecoration(labelText: 'Sensor Name'),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedHub,
                    items: const [
                      DropdownMenuItem(
                          value: 'HUB-NORTH-X1',
                          child: Text('HUB-NORTH-X1')),
                    ],
                    onChanged: (v) => setState(() => selectedHub = v!),
                    decoration:
                        const InputDecoration(labelText: 'Hub'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedType,
                    items: const [
                      DropdownMenuItem(
                          value: 'Temperature',
                          child: Text('Temperature')),
                      DropdownMenuItem(
                          value: 'CO2', child: Text('CO2')),
                    ],
                    onChanged: (v) => setState(() => selectedType = v!),
                    decoration:
                        const InputDecoration(labelText: 'Type'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
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
                        'name': nameCtrl.text,
                        'site': 'SITE-NORTH-01',
                        'value': '--',
                        'status': 'Normal',
                      });
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('REGISTER'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
