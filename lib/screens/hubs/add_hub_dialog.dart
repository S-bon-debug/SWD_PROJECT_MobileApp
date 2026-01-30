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
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF0A0A0A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: Colors.white12),
      ),
      child: SizedBox(
        width: 420,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// ================= HEADER =================
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'ADD NEW HUB',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white70),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(color: Colors.white12, height: 1),

              /// ================= FORM =================
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
                        color: Colors.white60,
                        letterSpacing: 0.6,
                      ),
                    ),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      value: selectedSite,
                      dropdownColor: const Color(0xFF141414),
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration(),
                      items: const [
                        DropdownMenuItem(
                          value: 'SITE-NORTH-01',
                          child: Text('SITE-NORTH-01'),
                        ),
                        DropdownMenuItem(
                          value: 'SITE-MAIN-04',
                          child: Text('SITE-MAIN-04'),
                        ),
                      ],
                      onChanged: (v) => setState(() => selectedSite = v!),
                    ),

                    const SizedBox(height: 18),

                    const Text(
                      'HUB NAME',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white60,
                        letterSpacing: 0.6,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: hubNameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration(
                        hint: 'e.g. HUB-NEW-GEN',
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Hub name is required';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),

              const Divider(color: Colors.white12, height: 1),

              /// ================= ACTIONS =================
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white70,
                          side: const BorderSide(color: Colors.white24),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text('CANCEL'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          if (!_formKey.currentState!.validate()) return;

                          widget.onSubmit({
                            'hubId': hubNameController.text.trim(),
                            'site': selectedSite,
                            'online': false,
                          });

                          Navigator.pop(context);
                        },
                        child: const Text(
                          'REGISTER HUB',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({String? hint}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white38),
      filled: true,
      fillColor: const Color(0xFF141414),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.white12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.white),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
    );
  }
}
