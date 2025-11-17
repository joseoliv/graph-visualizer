import 'package:flutter/material.dart';

class GraphRing {
  final int vertexCount;
  final Map<int, RingNode> nodes;
  final List<DirectedEdge> edges;

  GraphRing({required this.vertexCount})
      : nodes = {},
        edges = [] {
    _initializeNodes();
  }

  void _initializeNodes() {
    for (int i = 0; i < vertexCount; i++) {
      nodes[i] = RingNode(
        id: i,
        position: Offset.zero,
        colorList: const [Colors.black],
      );
    }
  }

  void updateNodePosition(int nodeId, Offset position) {
    if (nodes.containsKey(nodeId)) {
      nodes[nodeId] = nodes[nodeId]!.copyWith(position: position);
    }
  }

  // Replace entire color list (ensures max 4 and preserves order provided)
  void setNodeColors(int nodeId, List<Color> colors) {
    if (nodes.containsKey(nodeId)) {
      final capped = colors.take(4).toList();
      nodes[nodeId] = nodes[nodeId]!.copyWith(colorList: capped);
    }
  }

  List<Color> getNodeColors(int nodeId) {
    return nodes[nodeId]?.colorList ?? const [Colors.black];
  }

  void addNodeColor(int nodeId, Color color) {
    if (!nodes.containsKey(nodeId)) return;
    final current = [...nodes[nodeId]!.colorList];
    if (current.contains(color)) return;
    if (current.length >= 4) return;
    current.add(color);
    nodes[nodeId] = nodes[nodeId]!.copyWith(colorList: current);
  }

  bool removeNodeColor(int nodeId, Color color) {
    if (!nodes.containsKey(nodeId)) return false;
    final current = [...nodes[nodeId]!.colorList];
    final removed = current.remove(color);
    if (removed) {
      // Ensure at least one color remains; default to black if empty
      if (current.isEmpty) current.add(Colors.black);
      nodes[nodeId] = nodes[nodeId]!.copyWith(colorList: current);
    }
    return removed;
  }

  void addEdge(int fromNodeId, int toNodeId) {
    // Check if edge already exists
    bool edgeExists = edges.any(
        (edge) => edge.fromNodeId == fromNodeId && edge.toNodeId == toNodeId);

    if (!edgeExists && fromNodeId != toNodeId) {
      edges.add(DirectedEdge(
        fromNodeId: fromNodeId,
        toNodeId: toNodeId,
      ));
    }
  }

  void removeEdge(int fromNodeId, int toNodeId) {
    edges.removeWhere(
        (edge) => edge.fromNodeId == fromNodeId && edge.toNodeId == toNodeId);
  }

  bool hasEdge(int fromNodeId, int toNodeId) {
    return edges.any(
        (edge) => edge.fromNodeId == fromNodeId && edge.toNodeId == toNodeId);
  }

  bool hasReverseEdge(int fromNodeId, int toNodeId) {
    return edges.any(
        (edge) => edge.fromNodeId == toNodeId && edge.toNodeId == fromNodeId);
  }

  void clear() {
    nodes.clear();
    edges.clear();
  }
}

class RingNode {
  final int id;
  final Offset position;
  final List<Color> colorList;

  const RingNode({
    required this.id,
    required this.position,
    required this.colorList,
  });

  RingNode copyWith({
    int? id,
    Offset? position,
    List<Color>? colorList,
  }) {
    return RingNode(
      id: id ?? this.id,
      position: position ?? this.position,
      colorList: colorList ?? this.colorList,
    );
  }
}

class DirectedEdge {
  final int fromNodeId;
  final int toNodeId;

  const DirectedEdge({
    required this.fromNodeId,
    required this.toNodeId,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DirectedEdge &&
        other.fromNodeId == fromNodeId &&
        other.toNodeId == toNodeId;
  }

  @override
  int get hashCode => fromNodeId.hashCode ^ toNodeId.hashCode;
}
