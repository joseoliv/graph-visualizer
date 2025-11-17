import 'package:flutter/material.dart';
import '../models/graph_ring.dart';

class GraphPainter extends CustomPainter {
  final GraphRing graph;
  final double ringSize;

  GraphPainter({
    required this.graph,
    required this.ringSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Draw edges first (so they appear behind nodes)
    for (final edge in graph.edges) {
      final fromNode = graph.nodes[edge.fromNodeId];
      final toNode = graph.nodes[edge.toNodeId];
      
      if (fromNode != null && toNode != null) {
        _drawArrow(canvas, paint, fromNode, toNode);
      }
    }
  }

  void _drawArrow(Canvas canvas, Paint paint, RingNode fromNode, RingNode toNode) {
    final fromCenter = fromNode.position;
    final toCenter = toNode.position;
    
    // Calculate direction vector
    final direction = toCenter - fromCenter;
    final distance = direction.distance;
    
    if (distance < ringSize) return; // Don't draw if nodes are too close
    
    // Normalize direction vector
    final unitDirection = direction / distance;
    
    // Calculate start and end points (at the edge of the rings)
    final startPoint = fromCenter + unitDirection * (ringSize / 2);
    final endPoint = toCenter - unitDirection * (ringSize / 2);
    
    // Check if there's a reverse edge
    final hasReverseEdge = graph.hasReverseEdge(fromNode.id, toNode.id);
    
    if (hasReverseEdge && fromNode.id != toNode.id) {
      // Draw curved arrow for bidirectional edges
      _drawCurvedArrow(canvas, paint, startPoint, endPoint, fromCenter, toCenter);
    } else {
      // Draw straight arrow
      _drawStraightArrow(canvas, paint, startPoint, endPoint);
    }
  }

  void _drawStraightArrow(Canvas canvas, Paint paint, Offset start, Offset end) {
    // Draw line
    canvas.drawLine(start, end, paint);
    
    // Draw arrowhead
    _drawArrowhead(canvas, paint, start, end);
  }

  void _drawCurvedArrow(Canvas canvas, Paint paint, Offset start, Offset end, 
                       Offset fromCenter, Offset toCenter) {
    // Calculate control point for curve (30 degrees to the right)
    final midPoint = (fromCenter + toCenter) / 2;
    final direction = toCenter - fromCenter;
    final perpendicular = Offset(-direction.dy, direction.dx);
    final unitPerpendicular = perpendicular / perpendicular.distance;
    
    // Control point offset (adjust this value to change curve intensity)
    final controlPointOffset = unitPerpendicular * 30;
    final controlPoint = midPoint + controlPointOffset;
    
    // Create curved path
    final path = Path()
      ..moveTo(start.dx, start.dy)
      ..quadraticBezierTo(
        controlPoint.dx,
        controlPoint.dy,
        end.dx,
        end.dy,
      );
    
    canvas.drawPath(path, paint);
    
    // Draw arrowhead at the end of the curve
    _drawArrowhead(canvas, paint, controlPoint, end);
  }

  void _drawArrowhead(Canvas canvas, Paint paint, Offset from, Offset to) {
    const arrowSize = 10.0;
    const arrowAngle = 0.5; // ~30 degrees
    
    final direction = to - from;
    final unitDirection = direction / direction.distance;
    
    // Calculate arrowhead points
    final leftWing = to - unitDirection * arrowSize 
                     + Offset(-unitDirection.dy, unitDirection.dx) * arrowSize * arrowAngle;
    final rightWing = to - unitDirection * arrowSize 
                      + Offset(unitDirection.dy, -unitDirection.dx) * arrowSize * arrowAngle;
    
    // Draw arrowhead
    canvas.drawLine(to, leftWing, paint);
    canvas.drawLine(to, rightWing, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}