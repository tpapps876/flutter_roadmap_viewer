import 'package:flutter/material.dart';
import '../models/position_data.dart';
import '../models/roadmap_node.dart';
import '../models/roadmap_enums.dart';
import '../models/roadmap_theme.dart';
import '../utils/roadmap_color_utils.dart';

/// Paints edges (connections) between nodes in the roadmap.
class EdgePainter extends CustomPainter {
  /// Creates an edge painter.
  EdgePainter(
    this.nodes,
    this.positions, {
    this.nodeWidth = 120,
    this.nodeHeight = 60,
    this.style = EdgeStyle.orthogonal,
    this.orientation = RoadmapOrientation.horizontal,
    this.theme,
  });

  /// The nodes in the roadmap.
  final List<RoadmapNode> nodes;

  /// Map of node IDs to their positions.
  final Map<String, PositionData> positions;

  /// Width of each node.
  final double nodeWidth;

  /// Height of each node.
  final double nodeHeight;

  /// Style of edges (curved or orthogonal).
  final EdgeStyle style;

  /// Orientation of the roadmap.
  final RoadmapOrientation orientation;

  /// Theme configuration for edge styling.
  final RoadmapTheme? theme;

  @override
  void paint(Canvas canvas, Size size) {
    final defaultColor =
        theme?.edgeColor ?? Colors.blueGrey.withValues(alpha: 0.5);
    final strokeWidth = theme?.edgeWidth ?? 3.0;

    final paint = Paint()
      ..color = defaultColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final idToNode = {for (final n in nodes) n.id: n};
    final isCurved = style == EdgeStyle.curved;
    final isHorizontal = orientation == RoadmapOrientation.horizontal;

    for (final node in nodes) {
      final fromPos = positions[node.id];
      if (fromPos == null) continue;

      for (final childId in node.childIds) {
        final toPos = positions[childId];
        if (toPos == null) continue;

// Color edge based on child progress (if theme doesn't override)
        if (theme?.edgeColor == null) {
          final childNode = idToNode[childId];
          if (childNode != null) {
            paint.color = RoadmapColorUtils.colorForProgress(
              childNode.progress,
              theme: theme,
            );
          }
        }

        // Calculate start and end points
        final startX =
            isHorizontal ? fromPos.x + nodeWidth : fromPos.x + nodeWidth / 2;
        final startY =
            isHorizontal ? fromPos.y + nodeHeight / 2 : fromPos.y + nodeHeight;
        final endX = isHorizontal ? toPos.x : toPos.x + nodeWidth / 2;
        final endY = isHorizontal ? toPos.y + nodeHeight / 2 : toPos.y;

        final path = Path()..moveTo(startX, startY);

        if (isCurved) {
          _drawCurvedPath(path, startX, startY, endX, endY, isHorizontal);
        } else {
          _drawOrthogonalPath(path, startX, startY, endX, endY, isHorizontal);
        }

        canvas.drawPath(path, paint);
      }
    }
  }

  void _drawCurvedPath(
    Path path,
    double startX,
    double startY,
    double endX,
    double endY,
    bool isHorizontal,
  ) {
    if (isHorizontal) {
      final cp1X = startX + (endX - startX) / 2;
      final cp1Y = startY;
      final cp2X = startX + (endX - startX) / 2;
      final cp2Y = endY;
      path.cubicTo(cp1X, cp1Y, cp2X, cp2Y, endX, endY);
    } else {
      final cp1X = startX;
      final cp1Y = startY + (endY - startY) / 2;
      final cp2X = endX;
      final cp2Y = startY + (endY - startY) / 2;
      path.cubicTo(cp1X, cp1Y, cp2X, cp2Y, endX, endY);
    }
  }

  void _drawOrthogonalPath(
    Path path,
    double startX,
    double startY,
    double endX,
    double endY,
    bool isHorizontal,
  ) {
    if (isHorizontal) {
      final midX = startX + (endX - startX) / 2;
      path
        ..lineTo(midX, startY)
        ..lineTo(midX, endY)
        ..lineTo(endX, endY);
    } else {
      final midY = startY + (endY - startY) / 2;
      path
        ..lineTo(startX, midY)
        ..lineTo(endX, midY)
        ..lineTo(endX, endY);
    }
  }

  @override
  bool shouldRepaint(covariant EdgePainter oldDelegate) {
    return oldDelegate.nodes != nodes ||
        oldDelegate.positions != positions ||
        oldDelegate.style != style ||
        oldDelegate.orientation != orientation ||
        oldDelegate.theme != theme;
  }
}
