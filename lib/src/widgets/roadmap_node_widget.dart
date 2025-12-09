import 'package:flutter/material.dart';
import '../models/roadmap_node.dart';
import '../models/roadmap_node_style.dart';
import '../models/roadmap_theme.dart';
import '../utils/roadmap_color_utils.dart';

/// Widget that displays a single node in the roadmap.
class RoadmapNodeWidget extends StatelessWidget {
  /// Creates a roadmap node widget.
  const RoadmapNodeWidget({
    super.key,
    required this.node,
    this.style,
    this.overrideCourseLabel,
    this.onTap,
    this.theme,
  });

  /// The node to display.
  final RoadmapNode node;

  /// Style configuration for this node.
  /// If null, uses default styling based on node type and progress.
  final RoadmapNodeStyle? style;

  /// Override label for course nodes.
  final String? overrideCourseLabel;

  /// Callback when node is tapped.
  final VoidCallback? onTap;

  /// Theme configuration for colors.
  final RoadmapTheme? theme;

  @override
  Widget build(BuildContext context) {
    final effectiveStyle = style ?? _getDefaultStyle();

    final borderColor = effectiveStyle.borderColor ??
        RoadmapColorUtils.colorForProgress(node.progress, theme: theme);
    final fillColor = effectiveStyle.backgroundColor ??
        RoadmapColorUtils.colorForProgress(node.progress, theme: theme)
            .withValues(alpha: 0.2);

    final isCourse = node.nodeType.toLowerCase() == 'course';
    final borderRadius = effectiveStyle.borderRadius ??
        (isCourse
            ? BorderRadius.circular(effectiveStyle.height / 2)
            : BorderRadius.circular(12));

    final content = Container(
      width: effectiveStyle.width,
      height: effectiveStyle.height,
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius:
            effectiveStyle.shape == BoxShape.circle ? null : borderRadius,
        shape: effectiveStyle.shape ?? BoxShape.rectangle,
        border: Border.all(
          color: borderColor,
          width: effectiveStyle.borderWidth,
        ),
        boxShadow: effectiveStyle.shadows ??
            [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(2, 2),
              )
            ],
      ),
      alignment: Alignment.center,
      child: Padding(
        padding: effectiveStyle.padding,
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth:
                    effectiveStyle.width - effectiveStyle.padding.horizontal,
              ),
              child: Text(
                _getDisplayLabel(),
                textAlign: TextAlign.center,
                maxLines: 2,
                style: effectiveStyle.textStyle ??
                    const TextStyle(
                      color: Color(0xFF1E293B),
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      letterSpacing: -0.2,
                      height: 1.3,
                    ),
              ),
            ),
          ),
        ),
      ),
    );

    if (onTap == null) return content;
    return GestureDetector(onTap: onTap, child: content);
  }

  String _getDisplayLabel() {
    if (node.nodeType.toLowerCase() == 'course' &&
        overrideCourseLabel != null &&
        overrideCourseLabel!.isNotEmpty) {
      return overrideCourseLabel!;
    }
    return node.name ?? node.id;
  }

  RoadmapNodeStyle _getDefaultStyle() {
    final isCourse = node.nodeType.toLowerCase() == 'course';
    return isCourse
        ? RoadmapNodeStyle.courseStyle()
        : RoadmapNodeStyle.skillStyle();
  }
}
