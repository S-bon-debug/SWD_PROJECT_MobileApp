import 'package:flutter/material.dart';
import '../../services/sensor_service.dart';
import '../../services/hub_service.dart';
import '../../services/auth_service.dart';

class EditSensorDialog extends StatefulWidget {
  final dynamic sensor;
  final VoidCallback onSuccess;

  const EditSensorDialog({
    super.key,
    required this.sensor,
    required this.onSuccess,
  });

  @override
  State<EditSensorDialog> createState() => _EditSensorDialogState();
}

class _EditSensorDialogState extends State<EditSensorDialog> {
  final SensorService _sensorService = SensorService();
  final HubService _hubService = HubService();
  final TextEditingController nameCtrl = TextEditingController();

  List<dynamic> hubs = [];
  List<dynamic> types = [];
  int? selectedHubId;
  int? selectedTypeId;
  bool isLoadingData = true;
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  int? _parseInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '');
  }

  Future<void> _loadInitialData() async {
    try {
      final token = AuthService.token;
      if (token == null) return;

      final fetchedHubs = await _hubService.fetchHubs(token);
      final fetchedTypes = await _sensorService.fetchSensorTypes(token);

      final initialHubId = _parseInt(widget.sensor['hubId']);
      final initialTypeId = _parseInt(widget.sensor['typeId']);
      final initialName =
          (widget.sensor['sensorName'] ?? widget.sensor['name'] ?? '')
              .toString();

      setState(() {
        hubs = fetchedHubs;
        types = fetchedTypes;
        nameCtrl.text = initialName;

        if (initialHubId != null &&
            hubs.any((h) => _parseInt(h['hubId']) == initialHubId)) {
          selectedHubId = initialHubId;
        } else if (hubs.isNotEmpty) {
          selectedHubId = _parseInt(hubs[0]['hubId']);
        }

        if (initialTypeId != null &&
            types.any((t) => _parseInt(t['typeId']) == initialTypeId)) {
          selectedTypeId = initialTypeId;
        } else if (types.isNotEmpty) {
          selectedTypeId = _parseInt(types[0]['typeId']);
        }

        isLoadingData = false;
      });
    } catch (e) {
      debugPrint('Error loading edit sensor data: $e');
      setState(() => isLoadingData = false);
    }
  }

  Future<void> _handleUpdate() async {
    final sensorId = _parseInt(widget.sensor['sensorId']);
    if (sensorId == null ||
        nameCtrl.text.trim().isEmpty ||
        selectedHubId == null ||
        selectedTypeId == null) {
      return;
    }

    setState(() => isSubmitting = true);

    try {
      final token = AuthService.token;
      if (token == null) return;

      final success = await _sensorService.updateSensor(token, sensorId, {
        'name': nameCtrl.text.trim(),
        'hubId': selectedHubId,
        'typeId': selectedTypeId,
      });

      if (success) {
        widget.onSuccess();
        if (mounted) Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Loi: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: isLoadingData
            ? const SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'CHINH SUA CAM BIEN',
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
                  const Text(
                    'TEN CAM BIEN',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: nameCtrl,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      hintText: 'VD: TEMP-OUTDOOR-01',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _hubField()),
                      const SizedBox(width: 12),
                      Expanded(child: _typeField()),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('HUY'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed:
                              (nameCtrl.text.trim().isEmpty || isSubmitting)
                                  ? null
                                  : _handleUpdate,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                          ),
                          child: isSubmitting
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'CAP NHAT',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  Widget _hubField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'HUB',
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<int>(
          value: selectedHubId,
          isExpanded: true,
          items: hubs
              .map((h) {
                final id = _parseInt(h['hubId']);
                if (id == null) return null;
                return DropdownMenuItem<int>(
                  value: id,
                  child: Text(h['name']?.toString() ?? id.toString()),
                );
              })
              .whereType<DropdownMenuItem<int>>()
              .toList(),
          onChanged: (v) => setState(() => selectedHubId = v),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            isDense: true,
          ),
        ),
      ],
    );
  }

  Widget _typeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'LOAI',
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<int>(
          value: selectedTypeId,
          isExpanded: true,
          items: types
              .map((t) {
                final id = _parseInt(t['typeId']);
                if (id == null) return null;
                return DropdownMenuItem<int>(
                  value: id,
                  child: Text(t['typeName']?.toString() ?? id.toString()),
                );
              })
              .whereType<DropdownMenuItem<int>>()
              .toList(),
          onChanged: (v) => setState(() => selectedTypeId = v),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            isDense: true,
          ),
        ),
      ],
    );
  }
}
