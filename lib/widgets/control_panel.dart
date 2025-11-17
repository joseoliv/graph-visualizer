import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ControlPanel extends StatefulWidget {
  final int vertexCount;
  final Function(int) onVertexCountChanged;
  final VoidCallback onClearGraph;

  const ControlPanel({
    super.key,
    required this.vertexCount,
    required this.onVertexCountChanged,
    required this.onClearGraph,
  });

  @override
  State<ControlPanel> createState() => _ControlPanelState();
}

class _ControlPanelState extends State<ControlPanel> {
  late TextEditingController _controller;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.vertexCount.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateVertexCount() {
    final value = int.tryParse(_controller.text);
    if (value == null) {
      setState(() {
        _errorText = 'Please enter a valid number';
      });
      return;
    }

    if (value <= 0 || value >= 20) {
      setState(() {
        _errorText = 'Number must be between 1 and 19';
      });
      return;
    }

    setState(() {
      _errorText = null;
    });
    widget.onVertexCountChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Graph Controls',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Number of Vertices (1-19):',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                errorText: _errorText,
                hintText: 'Enter number < 20',
              ),
              onSubmitted: (_) => _updateVertexCount(),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _updateVertexCount,
                child: const Text('Update Graph'),
              ),
            ),
            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 16),
            const Text(
              'Instructions:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '• Drag rings to position them',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 4),
            const Text(
              '• Long-press a ring to change color',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 4),
            const Text(
              '• Double-tap a ring, then another to connect',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 4),
            const Text(
              '• Bidirectional arrows curve automatically',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: widget.onClearGraph,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                ),
                child: const Text('Clear Graph'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
