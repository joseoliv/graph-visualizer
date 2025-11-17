import 'package:flutter/material.dart';
import 'screens/graph_screen.dart';

void main() {
  runApp(const GraphVisualizerApp());
}

class GraphVisualizerApp extends StatelessWidget {
  const GraphVisualizerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Graph Ring Visualizer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const GraphScreen(),
    );
  }
}