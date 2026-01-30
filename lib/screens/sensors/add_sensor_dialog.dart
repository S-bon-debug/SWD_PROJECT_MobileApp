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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: SizedBox(
        width: 420,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'REGISTER SENSOR',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      letterSpacing: 0.8,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),

              const SizedBox(height: 20),

              /// SENSOR NAME
              const Text(
                'SENSOR NAME',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                  hintText: 'e.g. TEMP-OUTDOOR-01',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),

              const SizedBox(height: 16),

              /// HUB + TYPE
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'HUB',
                          style: TextStyle(
                              fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<String>(
                          value: selectedHub,
                          items: const [
                            DropdownMenuItem(
                              value: 'HUB-NORTH-X1',
                              child: Text('HUB-NORTH-X1'),
                            ),
                          ],
                          onChanged: (v) =>
                              setState(() => selectedHub = v!),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'TYPE',
                          style: TextStyle(
                              fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<String>(
                          value: selectedType,
                          items: const [
                            DropdownMenuItem(
                                value: 'Temperature',
                                child: Text('Temperature')),
                            DropdownMenuItem(
                                value: 'CO2', child: Text('CO2')),
                            DropdownMenuItem(
                                value: 'Humidity', child: Text('Humidity')),
                          ],
                          onChanged: (v) =>
                              setState(() => selectedType = v!),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              /// ACTIONS
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
                      onPressed: nameCtrl.text.trim().isEmpty
                          ? null
                          : () {
                              widget.onSubmit({
                                'name': nameCtrl.text.trim(),
                                'hub': selectedHub,
                                'type': selectedType,
                                'value': '--',
                                'status': 'Normal',
                              });
                              Navigator.pop(context);
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text(
                        'REGISTER',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
