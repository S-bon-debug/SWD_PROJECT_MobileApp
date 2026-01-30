import 'package:flutter/material.dart';

class AddSiteDialog extends StatefulWidget {
  final Function(Map<String, String>) onSubmit;

  const AddSiteDialog({super.key, required this.onSubmit});

  @override
  State<AddSiteDialog> createState() => _AddSiteDialogState();
}

class _AddSiteDialogState extends State<AddSiteDialog> {
  final nameController = TextEditingController();
  final addressController = TextEditingController();

  void _submit() {
    if (nameController.text.isEmpty || addressController.text.isEmpty) return;

    widget.onSubmit({
      'id': 'S-${DateTime.now().millisecondsSinceEpoch}',
      'name': nameController.text,
      'address': addressController.text,
    });

    Navigator.pop(context);
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white38),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white30),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF0B0B0B),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'ADD NEW SITE',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white54),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ),

            const SizedBox(height: 20),

            /// SITE NAME
            const Text(
              'SITE NAME',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: nameController,
              style: const TextStyle(color: Colors.white),
              cursorColor: Colors.white,
              decoration: _inputDecoration('e.g. WinMart Cầu Giấy'),
            ),

            const SizedBox(height: 16),

            /// ADDRESS
            const Text(
              'ADDRESS',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: addressController,
              style: const TextStyle(color: Colors.white),
              cursorColor: Colors.white,
              decoration: _inputDecoration('Full street address'),
            ),

            const SizedBox(height: 24),

            /// ACTIONS
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'CANCEL',
                    style: TextStyle(color: Colors.white54),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text(
                    'ADD SITE',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
