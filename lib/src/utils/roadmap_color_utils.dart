import 'package:flutter/material.dart';
import '../models/progress_status.dart';
import '../models/roadmap_theme.dart';

/// Utility functions for generating colors in the roadmap.
class RoadmapColorUtils {
  /// Returns a color based on progress status.
  ///
  /// If [theme] is provided, uses theme colors instead of defaults.
  static Color colorForProgress(ProgressStatus progress,
      {RoadmapTheme? theme}) {
    switch (progress) {
      case ProgressStatus.complete:
        return theme?.completeNodeColor ?? const Color(0xFF4CAF50);
      case ProgressStatus.current:
        return theme?.currentNodeColor ?? const Color(0xFF2196F3);
      case ProgressStatus.notStarted:
        return theme?.notStartedNodeColor ?? const Color(0xFF9E9E9E);
      case ProgressStatus.skipped:
        return theme?.skippedNodeColor ?? const Color(0xFFFF9800);
    }
  }

  /// Pastelizes a color by blending it with white.
  static Color pastelize(Color color, {double amount = 0.7}) {
    return Color.lerp(color, const Color(0xFFFFFFFF), amount) ?? color;
  }

  /// Returns a fill color for a node based on its layer.
  static Color layerFillColor(int layer, ColorScheme scheme,
      {RoadmapTheme? theme}) {
    if (theme?.defaultNodeColor != null) {
      return pastelize(theme!.defaultNodeColor!);
    }

    final colors = <Color>[
      pastelize(scheme.primary),
      pastelize(scheme.tertiary),
      pastelize(scheme.secondary),
      scheme.surfaceContainerHighest,
      scheme.inversePrimary.withValues(alpha: 0.15),
    ];
    return colors[layer % colors.length];
  }

  /// Returns a border color for a node based on its layer.
  static Color layerBorderColor(int layer, ColorScheme scheme,
      {RoadmapTheme? theme}) {
    if (theme?.defaultNodeColor != null) {
      return theme!.defaultNodeColor!;
    }

    final colors = <Color>[
      scheme.primary,
      scheme.tertiary,
      scheme.secondary,
      scheme.outline,
      scheme.primary,
    ];
    return colors[layer % colors.length];
  }
}
