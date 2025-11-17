import 'package:flutter/material.dart';

class RingWidget extends StatefulWidget {
  final int nodeId;
  final Offset position;
  final List<Color> colors;
  final double size;
  final Function(int, Offset) onPositionChanged;
  final Function(int) onColorChangeRequested;
  final Function(int) onDoubleTap;
  final bool isSelected;

  const RingWidget({
    super.key,
    required this.nodeId,
    required this.position,
    required this.colors,
    required this.size,
    required this.onPositionChanged,
    required this.onColorChangeRequested,
    required this.onDoubleTap,
    this.isSelected = false,
  });

  @override
  State<RingWidget> createState() => _RingWidgetState();
}

class _RingWidgetState extends State<RingWidget> {
  Offset _dragOffset = Offset.zero;
  bool _isDragging = false;
  // Holds up to 4 colors; first is the outer ring
  late List<Color> colorList;

  static const double ringThickness = 3.0;

  @override
  void initState() {
    super.initState();
    colorList = List<Color>.from(widget.colors);
  }

  @override
  void didUpdateWidget(covariant RingWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.colors != widget.colors) {
      colorList = List<Color>.from(widget.colors);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.position.dx - widget.size / 2,
      top: widget.position.dy - widget.size / 2,
      child: GestureDetector(
        onPanStart: (details) {
          setState(() {
            _isDragging = true;
            // Calculate offset from ring center to drag start point
            final ringCenter = widget.position;
            final dragStart = details.globalPosition;
            _dragOffset = dragStart - ringCenter;
          });
        },
        onPanUpdate: (details) {
          if (_isDragging) {
            // Use global position for smooth movement
            final newPosition = details.globalPosition - _dragOffset;
            widget.onPositionChanged(widget.nodeId, newPosition);
          }
        },
        onPanEnd: (details) {
          setState(() {
            _isDragging = false;
          });
        },
        onLongPress: () {
          widget.onColorChangeRequested(widget.nodeId);
        },
        onDoubleTap: () {
          widget.onDoubleTap(widget.nodeId);
        },
        child: _buildMultiRing(),
      ),
    );
  }

  Widget _buildMultiRing() {
    // Order is provided by parent; draw outermost first at full size,
    // then shrink radius for inner rings while keeping uniform thickness
    final outerColor = colorList.isNotEmpty ? colorList.first : Colors.black;
    final rings = <Widget>[];
    final maxRings = colorList.length.clamp(1, 4);

    for (int i = 0; i < maxRings; i++) {
      final shrink = i * (ringThickness + 3.0); // small gap between rings
      final size = (widget.size - 2 * shrink).clamp(0.0, widget.size);
      if (size <= 0) continue;
      final color = colorList[i];
      rings.add(Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: color, width: ringThickness),
          color: Colors.transparent,
        ),
      ));
    }

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ...rings,
          if (widget.isSelected)
            Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: outerColor.withOpacity(0.4),
                    blurRadius: 10,
                    spreadRadius: 2,
                  )
                ],
              ),
            ),
          Center(
            child: Text(
              '${widget.nodeId}',
              style: TextStyle(
                //color: outerColor,
                fontSize: widget.size * 0.3,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
