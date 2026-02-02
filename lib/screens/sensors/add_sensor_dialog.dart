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
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isMobile = constraints.maxWidth < 500;

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ===== HEADER =====
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
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                /// ===== SENSOR NAME =====
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

                /// ===== HUB + TYPE =====
                isMobile
                    ? Column(
                        children: [
                          _hubField(),
                          const SizedBox(height: 12),
                          _typeField(),
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(child: _hubField()),
                          const SizedBox(width: 12),
                          Expanded(child: _typeField()),
                        ],
                      ),

                const SizedBox(height: 24),

                /// ===== ACTIONS =====
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
            );
          },
        ),
      ),
    );
  }

  /// ===== HUB FIELD =====
  Widget _hubField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'HUB',
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: selectedHub,
          isExpanded: true,
          items: const [
            DropdownMenuItem(
              value: 'HUB-NORTH-X1',
              child: Text('HUB-NORTH-X1'),
            ),
            DropdownMenuItem(
              value: 'HUB-772-AX',
              child: Text('HUB-772-AX'),
            ),
          ],
          onChanged: (v) => setState(() => selectedHub = v!),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            isDense: true,
          ),
        ),
      ],
    );
  }

  /// ===== TYPE FIELD =====
  Widget _typeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'TYPE',
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: selectedType,
          isExpanded: true,
          items: const [
            DropdownMenuItem(
              value: 'Temperature',
              child: Text('Temperature'),
            ),
            DropdownMenuItem(
              value: 'CO2',
              child: Text('CO2'),
            ),
            DropdownMenuItem(
              value: 'Humidity',
              child: Text('Humidity'),
            ),
          ],
          onChanged: (v) => setState(() => selectedType = v!),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            isDense: true,
          ),
        ),
      ],
    );
  }
}
