import 'package:flutter/material.dart';
import '../../services/alert_service.dart';
import '../../services/auth_service.dart';
import '../../services/sensor_service.dart';

class SensorAlertRuleDialog extends StatefulWidget {
  final int ruleId;
  final VoidCallback? onSuccess;

  const SensorAlertRuleDialog({
    super.key,
    required this.ruleId,
    this.onSuccess,
  });

  @override
  State<SensorAlertRuleDialog> createState() => _SensorAlertRuleDialogState();
}

class _SensorAlertRuleDialogState extends State<SensorAlertRuleDialog> {
  final _formKey = GlobalKey<FormState>();
  final _alertService = AlertService();
  final _sensorService = SensorService();

  final _nameCtrl = TextEditingController();
  final _minCtrl = TextEditingController();
  final _maxCtrl = TextEditingController();

  bool _loading = true;
  bool _saving = false;

  String _conditionType = 'MinMax';
  String _notificationMethod = 'Email';
  String _priority = 'High';
  bool _isActive = true;
  int? _selectedTypeId;

  List<dynamic> _types = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _minCtrl.dispose();
    _maxCtrl.dispose();
    super.dispose();
  }

  int? _parseInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '');
  }

  List<dynamic> _dedupeTypesByName(List<dynamic> source) {
    final seen = <String>{};
    final result = <dynamic>[];
    for (final t in source) {
      if (t is! Map) continue;
      final name = (t['typeName'] ?? t['name'] ?? '').toString().trim();
      if (name.isEmpty) continue;
      final key = name.toLowerCase();
      if (seen.contains(key)) continue;
      seen.add(key);
      result.add(t);
    }
    return result;
  }

  Future<void> _loadData() async {
    try {
      final token = AuthService.token;
      if (token == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No session found')),
          );
        }
        return;
      }

      final results = await Future.wait([
        _alertService.getAlertRuleById(token, widget.ruleId),
        _sensorService.fetchSensorTypes(token),
      ]);

      final rule = results[0] as Map<String, dynamic>?;
      final types = _dedupeTypesByName(results[1] as List<dynamic>);

      if (rule == null) {
        throw Exception('Rule not found');
      }

      final typeId = _parseInt(rule['typeId']);

      if (!mounted) return;
      setState(() {
        _types = types;
        _nameCtrl.text = (rule['name'] ?? '').toString();
        _minCtrl.text = (rule['minVal'] ?? '').toString();
        _maxCtrl.text = (rule['maxVal'] ?? '').toString();
        _conditionType = (rule['conditionType'] ?? 'MinMax').toString();
        _notificationMethod =
            (rule['notificationMethod'] ?? 'Email').toString();
        _priority = (rule['priority'] ?? 'High').toString();
        _isActive = rule['isActive'] == true;

        if (typeId != null &&
            _types.any((t) => _parseInt(t['typeId']) == typeId)) {
          _selectedTypeId = typeId;
        } else if (_types.isNotEmpty) {
          _selectedTypeId = _parseInt(_types.first['typeId']);
        }

        _loading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading rule: $e')),
        );
      }
    }
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedTypeId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select sensor type')),
      );
      return;
    }

    setState(() => _saving = true);

    try {
      final token = AuthService.token;
      if (token == null) return;

      final payload = {
        'name': _nameCtrl.text.trim(),
        'conditionType': _conditionType,
        'minVal': double.tryParse(_minCtrl.text.trim()),
        'maxVal': double.tryParse(_maxCtrl.text.trim()),
        'notificationMethod': _notificationMethod,
        'priority': _priority,
        'typeId': _selectedTypeId,
        'isActive': _isActive,
      };

      final success =
          await _alertService.updateAlertRule(token, widget.ruleId, payload);
      if (!mounted) return;

      if (success) {
        widget.onSuccess?.call();
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update alert rule')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF141414),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: _loading
              ? const SizedBox(
                  height: 180,
                  child: Center(child: CircularProgressIndicator()),
                )
              : Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Flexible(
                            child: Text(
                              'CONFIG ALERT RULE',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            icon:
                                const Icon(Icons.close, color: Colors.white54),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const Divider(color: Colors.white12),
                      const SizedBox(height: 10),
                      _label('RULE NAME'),
                      TextFormField(
                        controller: _nameCtrl,
                        style: const TextStyle(color: Colors.white),
                        decoration: _inputDecoration('Rule name'),
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Required' : null,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _label('MIN VALUE'),
                                TextFormField(
                                  controller: _minCtrl,
                                  style: const TextStyle(color: Colors.white),
                                  keyboardType: TextInputType.number,
                                  decoration: _inputDecoration('0'),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _label('MAX VALUE'),
                                TextFormField(
                                  controller: _maxCtrl,
                                  style: const TextStyle(color: Colors.white),
                                  keyboardType: TextInputType.number,
                                  decoration: _inputDecoration('100'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _label('SENSOR TYPE'),
                      _dropdown<int>(
                        value: _selectedTypeId,
                        items: _types
                            .map((t) => DropdownMenuItem<int>(
                                  value: _parseInt(t['typeId']),
                                  child: Text(
                                    (t['typeName'] ?? t['name'] ?? 'Unknown')
                                        .toString(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ))
                            .where((e) => e.value != null)
                            .cast<DropdownMenuItem<int>>()
                            .toList(),
                        onChanged: (v) => setState(() => _selectedTypeId = v),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _label('CONDITION'),
                                _dropdown<String>(
                                  value: _conditionType,
                                  items: const [
                                    DropdownMenuItem(
                                        value: 'MinMax',
                                        child: Text('MinMax',
                                            style: TextStyle(
                                                color: Colors.white))),
                                    DropdownMenuItem(
                                        value: 'GreaterThan',
                                        child: Text('GreaterThan',
                                            style: TextStyle(
                                                color: Colors.white))),
                                    DropdownMenuItem(
                                        value: 'LessThan',
                                        child: Text('LessThan',
                                            style: TextStyle(
                                                color: Colors.white))),
                                  ],
                                  onChanged: (v) => setState(
                                      () => _conditionType = v ?? 'MinMax'),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _label('PRIORITY'),
                                _dropdown<String>(
                                  value: _priority,
                                  items: const [
                                    DropdownMenuItem(
                                        value: 'Low',
                                        child: Text('Low',
                                            style: TextStyle(
                                                color: Colors.white))),
                                    DropdownMenuItem(
                                        value: 'Medium',
                                        child: Text('Medium',
                                            style: TextStyle(
                                                color: Colors.white))),
                                    DropdownMenuItem(
                                        value: 'High',
                                        child: Text('High',
                                            style: TextStyle(
                                                color: Colors.white))),
                                  ],
                                  onChanged: (v) =>
                                      setState(() => _priority = v ?? 'High'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _label('NOTIFICATION'),
                      _dropdown<String>(
                        value: _notificationMethod,
                        items: const [
                          DropdownMenuItem(
                              value: 'Email',
                              child: Text('Email',
                                  style: TextStyle(color: Colors.white))),
                          DropdownMenuItem(
                              value: 'SMS',
                              child: Text('SMS',
                                  style: TextStyle(color: Colors.white))),
                          DropdownMenuItem(
                              value: 'All Channels',
                              child: Text('All Channels',
                                  style: TextStyle(color: Colors.white))),
                        ],
                        onChanged: (v) =>
                            setState(() => _notificationMethod = v ?? 'Email'),
                      ),
                      const SizedBox(height: 8),
                      SwitchListTile(
                        value: _isActive,
                        activeColor: Colors.blueAccent,
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Active',
                            style: TextStyle(color: Colors.white70)),
                        onChanged: (v) => setState(() => _isActive = v),
                      ),
                      const SizedBox(height: 16),
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
                              onPressed: _saving ? null : _handleSave,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1A1F2C),
                              ),
                              child: _saving
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text('UPDATE',
                                      style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white38,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white24, fontSize: 13),
      filled: true,
      fillColor: Colors.black26,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white.withOpacity(0.12)),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.blueAccent),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget _dropdown<T>({
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          dropdownColor: const Color(0xFF141414),
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white54),
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
