import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graph_visualizer/main.dart';
import 'package:graph_visualizer/models/graph_ring.dart';

void main() {
  testWidgets('App launches successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const GraphVisualizerApp());

    expect(find.text('Graph Ring Visualizer'), findsOneWidget);
    expect(find.text('Graph Controls'), findsOneWidget);
  });

  test('GraphRing initialization creates correct number of nodes', () {
    final graph = GraphRing(vertexCount: 5);

    expect(graph.nodes.length, 5);
    expect(graph.vertexCount, 5);
    expect(graph.edges.isEmpty, true);
  });

  test('GraphRing node position updates correctly', () {
    final graph = GraphRing(vertexCount: 3);
    const newPosition = Offset(100, 200);

    graph.updateNodePosition(0, newPosition);

    expect(graph.nodes[0]!.position, newPosition);
  });

  test('GraphRing color updates correctly', () {
    final graph = GraphRing(vertexCount: 3);
    const newColor = Colors.red;

    // add a color
    graph.addNodeColor(0, newColor);

    expect(graph.nodes[0]!.colorList.contains(newColor), true);

    // set ordered colors
    graph.setNodeColors(0, const [Colors.red, Colors.black]);
    expect(graph.nodes[0]!.colorList.first, anyOf(Colors.red, Colors.black));
  });

  test('GraphRing edge creation works correctly', () {
    final graph = GraphRing(vertexCount: 3);

    graph.addEdge(0, 1);

    expect(graph.edges.length, 1);
    expect(graph.hasEdge(0, 1), true);
    expect(graph.hasEdge(1, 0), false);
  });

  test('GraphRing prevents duplicate edges', () {
    final graph = GraphRing(vertexCount: 3);

    graph.addEdge(0, 1);
    graph.addEdge(0, 1); // Duplicate

    expect(graph.edges.length, 1);
  });

  test('GraphRing detects reverse edges correctly', () {
    final graph = GraphRing(vertexCount: 3);

    graph.addEdge(0, 1);
    graph.addEdge(1, 0);

    expect(graph.hasReverseEdge(0, 1), true);
    expect(graph.hasReverseEdge(1, 0), true);
  });

  test('GraphRing edge removal works correctly', () {
    final graph = GraphRing(vertexCount: 3);

    graph.addEdge(0, 1);
    expect(graph.edges.length, 1);

    graph.removeEdge(0, 1);
    expect(graph.edges.isEmpty, true);
  });
}
