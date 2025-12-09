import 'package:flutter/material.dart';

/// Configuration for individual node appearance and styling.
///
/// This class allows users to customize how nodes look in the roadmap,
/// including dimensions, colors, borders, text style, and shadows.
class RoadmapNodeStyle {
  /// Creates a node style configuration.
  const RoadmapNodeStyle({
    this.width = 120.0,
    this.height = 60.0,
    this.borderWidth = 3.0,
    this.borderRadius,
    this.backgroundColor,
    this.borderColor,
    this.textStyle,
    this.padding = const EdgeInsets.all(8.0),
    this.shadows,
    this.shape,
  });

  /// Width of the node.
  final double width;

  /// Height of the node.
  final double height;

  /// Width of the node border.
  final double borderWidth;

  /// Border radius for the node.
  /// If null, defaults based on node type (pill for courses, rounded rect for skills).
  final BorderRadius? borderRadius;

  /// Background color of the node.
  /// If null, uses progress-based color.
  final Color? backgroundColor;

  /// Border color of the node.
  /// If null, uses progress-based color.
  final Color? borderColor;

  /// Text style for the node label.
  final TextStyle? textStyle;

  /// Padding inside the node container.
  final EdgeInsets padding;

  /// Box shadows for the node.
  final List<BoxShadow>? shadows;

  /// Custom shape for the node.
  /// If provided, overrides borderRadius.
  final BoxShape? shape;

  /// Creates a copy of this style with some fields replaced.
  RoadmapNodeStyle copyWith({
    double? width,
    double? height,
    double? borderWidth,
    BorderRadius? borderRadius,
    Color? backgroundColor,
    Color? borderColor,
    TextStyle? textStyle,
    EdgeInsets? padding,
    List<BoxShadow>? shadows,
    BoxShape? shape,
  }) {
    return RoadmapNodeStyle(
      width: width ?? this.width,
      height: height ?? this.height,
      borderWidth: borderWidth ?? this.borderWidth,
      borderRadius: borderRadius ?? this.borderRadius,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderColor: borderColor ?? this.borderColor,
      textStyle: textStyle ?? this.textStyle,
      padding: padding ?? this.padding,
      shadows: shadows ?? this.shadows,
      shape: shape ?? this.shape,
    );
  }

  /// Default style with common shadow.
  static RoadmapNodeStyle get defaultStyle {
    return RoadmapNodeStyle(
      shadows: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06),
          blurRadius: 8,
          offset: const Offset(0, 2),
          spreadRadius: 0,
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 16,
          offset: const Offset(0, 4),
          spreadRadius: 0,
        ),
      ],
    );
  }

  /// Style for course-type nodes (pill shape).
  factory RoadmapNodeStyle.courseStyle({
    double width = 150,
    double height = 70,
    Color? backgroundColor,
    Color? borderColor,
  }) {
    return RoadmapNodeStyle(
      width: width,
      height: height,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      borderRadius: BorderRadius.circular(height / 2),
      borderWidth: 2.5, // Slightly thinner
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shadows: defaultStyle.shadows,
    );
  }

  factory RoadmapNodeStyle.skillStyle({
    double width = 120,
    double height = 60,
    Color? backgroundColor,
    Color? borderColor,
  }) {
    return RoadmapNodeStyle(
      width: width,
      height: height,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      borderRadius: BorderRadius.circular(10), // Slightly smaller radius
      borderWidth: 2.5, // Consistent with course
      padding: const EdgeInsets.all(10),
      shadows: defaultStyle.shadows,
    );
  }
}
