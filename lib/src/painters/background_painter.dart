import 'package:flutter/material.dart';
import '../models/roadmap_node.dart';
import '../models/roadmap_enums.dart';
import '../models/roadmap_theme.dart';

/// Paints a background for the roadmap.
class BackgroundPainter extends CustomPainter {
  /// Creates a background painter.
  BackgroundPainter(
    this.nodes, {
    this.orientation = RoadmapOrientation.horizontal,
    this.theme,
  });

  /// The nodes in the roadmap.
  final List<RoadmapNode> nodes;

  /// The orientation of the roadmap.
  final RoadmapOrientation orientation;

  /// Theme configuration for background styling.
  final RoadmapTheme? theme;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    if (theme?.backgroundGradient != null) {
      paint.shader = theme!.backgroundGradient!.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );
    } else if (theme?.backgroundColor != null) {
      paint.color = theme!.backgroundColor!;
    } else {
      // Softer, more professional default gradient
      paint.shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFFAFAFA), // Subtle warm white
          Color(0xFFF5F5F7), // Apple-like gray
          Color(0xFFF0F4F8), // Cool gray-blue
        ],
        stops: [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    }

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant BackgroundPainter oldDelegate) {
    return oldDelegate.theme != theme;
  }
}
