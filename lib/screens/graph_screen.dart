import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/graph_ring.dart';
import '../widgets/control_panel.dart';
import '../widgets/ring_widget.dart';
import '../widgets/graph_painter.dart';

// Shared color order used for drawing and selection
const List<Color> kColorOrder = [
  Colors.black,
  Colors.red,
  Colors.blue,
  Colors.green,
  Colors.yellow,
  Colors.orange,
  Colors.purple,
  Colors.pink,
  Colors.teal,
  Colors.cyan,
  Colors.brown,
  Colors.grey,
];

class GraphScreen extends StatefulWidget {
  const GraphScreen({super.key});

  @override
  State<GraphScreen> createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen> {
  GraphRing? graph;
  int vertexCount = 5;
  int? selectedNodeForConnection;
  final double ringSize = 60.0;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    graph = GraphRing(vertexCount: vertexCount);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _distributeNodesEvenly();
      _isInitialized = true;
    }
  }

  void _initializeGraph() {
    graph = GraphRing(vertexCount: vertexCount);
    _distributeNodesEvenly();
  }

  void _distributeNodesEvenly() {
    if (graph == null) return;

    final screenWidth = MediaQuery.of(context).size.width;
    final availableWidth = screenWidth * 2 / 3; // Right panel width
    final availableHeight = MediaQuery.of(context).size.height;

    // Calculate grid layout
    final cols = (availableWidth / 150).floor();
    final rows = ((vertexCount + cols - 1) / cols).floor();

    int index = 0;
    for (int row = 0; row < rows && index < vertexCount; row++) {
      for (int col = 0; col < cols && index < vertexCount; col++) {
        final x = 100 + col * 120.0 + (availableWidth - cols * 120) / 2;
        final y = 100 + row * 120.0 + (availableHeight - rows * 120) / 2;

        graph!.updateNodePosition(index, Offset(x, y));
        index++;
      }
    }
  }

  void _updateVertexCount(int newCount) {
    setState(() {
      vertexCount = newCount;
      graph = GraphRing(vertexCount: newCount);
      _distributeNodesEvenly();
      selectedNodeForConnection = null;
    });
  }

  void _updateNodePosition(int nodeId, Offset position) {
    setState(() {
      graph?.updateNodePosition(nodeId, position);
    });
  }

  void _showColorPicker(int nodeId) {
    Color? selectedColor;
    final rootContext = context;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setLocalState) {
            return AlertDialog(
              title: const Text('Edit Ring Colors'),
              content: SingleChildScrollView(
                child: ColorPicker(
                  onColorSelected: (color) {
                    setLocalState(() {
                      selectedColor = color;
                    });
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    if (selectedColor == null) {
                      _showSnack(rootContext, 'Choose a color to remove');
                      return;
                    }
                    final colors =
                        graph?.getNodeColors(nodeId) ?? const [Colors.black];
                    if (!colors.contains(selectedColor)) {
                      _showSnack(rootContext, 'Ring does not have this color');
                      return;
                    }
                    setState(() {
                      graph?.removeNodeColor(nodeId, selectedColor!);
                    });
                  },
                  child: const Text('Remove color'),
                ),
                TextButton(
                  onPressed: () {
                    if (selectedColor == null) {
                      _showSnack(rootContext, 'Choose a color to add');
                      return;
                    }
                    final colors = [
                      ...(graph?.getNodeColors(nodeId) ?? const [Colors.black])
                    ];
                    if (colors.contains(selectedColor)) {
                      _showSnack(rootContext, 'Color already in ring');
                      return;
                    }
                    if (colors.length >= 4) {
                      _showSnack(rootContext, 'Max 4 colors per ring');
                      return;
                    }
                    colors.add(selectedColor!);
                    final ordered = _orderedByPalette(colors);
                    setState(() {
                      graph?.setNodeColors(nodeId, ordered);
                    });
                  },
                  child: const Text('Add new color'),
                ),
                TextButton(
                  onPressed: () {
                    if (selectedColor == null) {
                      _showSnack(rootContext, 'Choose a color to add');
                      return;
                    }
                    final colors = [
                      ...(graph?.getNodeColors(nodeId) ?? const [Colors.black])
                    ];
                    if (selectedColor == Colors.black) {
                      _showSnack(rootContext, 'Cannot replace with black');
                      return;
                    }
                    if (colors.contains(selectedColor)) {
                      _showSnack(rootContext, 'Color already in ring');
                      return;
                    }
                    if (colors.length >= 4) {
                      _showSnack(rootContext, 'Max 4 colors per ring');
                      return;
                    }

                    /// remove black if present
                    colors.remove(Colors.black);
                    colors.add(selectedColor!);
                    final ordered = _orderedByPalette(colors);
                    setState(() {
                      graph?.setNodeColors(nodeId, ordered);
                    });
                  },
                  child: const Text('Replace black by selected'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Done'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  List<Color> _orderedByPalette(List<Color> colors) {
    final orderMap = {
      for (int i = 0; i < kColorOrder.length; i++) kColorOrder[i]: i
    };
    final unique = colors.toSet().toList();
    unique.sort((a, b) => (orderMap[a] ?? 999).compareTo(orderMap[b] ?? 999));
    return unique;
  }

  void _showSnack(BuildContext ctx, String msg) {
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 1)),
    );
  }

  void _handleNodeDoubleTap(int nodeId) {
    setState(() {
      if (selectedNodeForConnection == null) {
        selectedNodeForConnection = nodeId;
      } else if (selectedNodeForConnection == nodeId) {
        selectedNodeForConnection = null;
      } else {
        // Create edge between selected nodes
        graph?.addEdge(selectedNodeForConnection!, nodeId);
        selectedNodeForConnection = null;
      }
    });
  }

  void _clearGraph() {
    setState(() {
      graph?.clear();
      _initializeGraph();
      selectedNodeForConnection = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Graph Ring Visualizer'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Row(
        children: [
          // Left panel (1/3 of screen)
          SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            child: ControlPanel(
              vertexCount: vertexCount,
              onVertexCountChanged: _updateVertexCount,
              onClearGraph: _clearGraph,
            ),
          ),
          // Right panel (2/3 of screen)
          Expanded(
            child: Container(
              color: Colors.grey[100],
              child: graph != null
                  ? Stack(
                      children: [
                        // Draw edges
                        CustomPaint(
                          size: Size.infinite,
                          painter: GraphPainter(
                            graph: graph!,
                            ringSize: ringSize,
                          ),
                        ),
                        // Draw nodes
                        ...graph!.nodes.entries.map((entry) {
                          final node = entry.value;
                          return RingWidget(
                            nodeId: node.id,
                            position: node.position,
                            colors: node.colorList,
                            size: ringSize,
                            onPositionChanged: _updateNodePosition,
                            onColorChangeRequested: _showColorPicker,
                            onDoubleTap: _handleNodeDoubleTap,
                            isSelected: selectedNodeForConnection == node.id,
                          );
                        }),
                      ],
                    )
                  : const Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }
}

class ColorPicker extends StatefulWidget {
  final Function(Color) onColorSelected;

  const ColorPicker({super.key, required this.onColorSelected});

  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  Color selectedColor = Colors.black;
  final List<Color> colors = kColorOrder;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: colors.map((color) {
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedColor = color;
            });
            widget.onColorSelected(color);
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: selectedColor == color ? Colors.black : Colors.grey,
                width: selectedColor == color ? 3 : 1,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
