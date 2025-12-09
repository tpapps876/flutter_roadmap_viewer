import 'package:flutter/material.dart';

/// Theme configuration for the entire roadmap visualization.
///
/// Controls global styling like background colors, gradients,
/// node colors based on progress status, and edge colors.
class RoadmapTheme {
  /// Creates a roadmap theme.
  const RoadmapTheme({
    this.backgroundColor,
    this.backgroundGradient,
    this.defaultNodeColor,
    this.completeNodeColor = const Color(0xFF10B981), // Refined green
    this.currentNodeColor = const Color(0xFF3B82F6), // Refined blue
    this.notStartedNodeColor = const Color(0xFF94A3B8), // Softer gray
    this.skippedNodeColor = const Color(0xFFF59E0B), // Refined amber
    this.edgeColor,
    this.edgeWidth = 2.5, // Slightly thinner for elegance
  });

  /// Solid background color for the roadmap canvas.
  /// If both this and [backgroundGradient] are null, uses default gradient.
  final Color? backgroundColor;

  /// Gradient background for the roadmap canvas.
  /// Takes precedence over [backgroundColor].
  final Gradient? backgroundGradient;

  /// Default color for nodes when not using progress-based coloring.
  final Color? defaultNodeColor;

  /// Color for nodes with complete status.
  final Color completeNodeColor;

  /// Color for nodes with current/in-progress status.
  final Color currentNodeColor;

  /// Color for nodes with not started status.
  final Color notStartedNodeColor;

  /// Color for nodes with skipped status.
  final Color skippedNodeColor;

  /// Color for edges connecting nodes.
  /// If null, edges use progress-based coloring.
  final Color? edgeColor;

  /// Width of edges connecting nodes.
  final double edgeWidth;

  /// Creates a copy with some fields replaced.
  RoadmapTheme copyWith({
    Color? backgroundColor,
    Gradient? backgroundGradient,
    Color? defaultNodeColor,
    Color? completeNodeColor,
    Color? currentNodeColor,
    Color? notStartedNodeColor,
    Color? skippedNodeColor,
    Color? edgeColor,
    double? edgeWidth,
  }) {
    return RoadmapTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      backgroundGradient: backgroundGradient ?? this.backgroundGradient,
      defaultNodeColor: defaultNodeColor ?? this.defaultNodeColor,
      completeNodeColor: completeNodeColor ?? this.completeNodeColor,
      currentNodeColor: currentNodeColor ?? this.currentNodeColor,
      notStartedNodeColor: notStartedNodeColor ?? this.notStartedNodeColor,
      skippedNodeColor: skippedNodeColor ?? this.skippedNodeColor,
      edgeColor: edgeColor ?? this.edgeColor,
      edgeWidth: edgeWidth ?? this.edgeWidth,
    );
  }

  /// Default theme with soft blue-mint gradient.
  static const RoadmapTheme defaultTheme = RoadmapTheme();

  /// Dark theme for roadmaps.
  static RoadmapTheme darkTheme() {
    return const RoadmapTheme(
      backgroundColor: Color(0xFF0F172A), // Slate 900
      completeNodeColor: Color(0xFF10B981), // Emerald 500
      currentNodeColor: Color(0xFF3B82F6), // Blue 500
      notStartedNodeColor: Color(0xFF64748B), // Slate 500
      skippedNodeColor: Color(0xFFF59E0B), // Amber 500
      edgeColor: Color(0xFF334155), // Slate 700
      edgeWidth: 2.5,
    );
  }

  /// Light theme with minimal colors.
  static RoadmapTheme lightTheme() {
    return const RoadmapTheme(
      backgroundColor: Color(0xFFFFFFFF),
      completeNodeColor: Color(0xFF10B981),
      currentNodeColor: Color(0xFF3B82F6),
      notStartedNodeColor: Color(0xFFD1D5DB), // Gray 300
      skippedNodeColor: Color(0xFFF59E0B),
      edgeColor: Color(0xFFE5E7EB), // Gray 200
      edgeWidth: 2.5,
    );
  }

  /// Vibrant theme with bold colors.
  static RoadmapTheme vibrantTheme() {
    return const RoadmapTheme(
      completeNodeColor: Color(0xFF059669), // Emerald 600
      currentNodeColor: Color(0xFF2563EB), // Blue 600
      notStartedNodeColor: Color(0xFF475569), // Slate 600
      skippedNodeColor: Color(0xFFD97706), // Amber 600
      edgeWidth: 3.0,
    );
  }
}
