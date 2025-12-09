import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models/roadmap_node.dart';
import '../models/roadmap_node_style.dart';
import '../models/roadmap_enums.dart';
import '../models/roadmap_theme.dart';
import '../layout/parent_aware_layout_engine.dart';
import '../layout/roadmap_layout_utils.dart';
import '../utils/roadmap_color_utils.dart';
import '../painters/background_painter.dart';
import '../painters/edge_painter.dart';
import 'roadmap_node_widget.dart';
import 'roadmap_fit_button.dart';

/// A highly customizable roadmap/skill tree visualization widget.
///
/// Displays nodes in a hierarchical layout with parent-child relationships,
/// supports interactive pan/zoom, and offers multiple layout orientations.
///
/// ## Node Sizing
///
/// Currently, all nodes must have the same dimensions for proper layout.
/// The [nodeWidth] and [nodeHeight] parameters set the size for all nodes.
///
/// If using [nodeStyleProvider], ensure all returned styles use the same
/// width and height values to avoid layout issues.
///
/// ## Basic Example
/// ```dart
/// RoadmapViewer(
///   nodes: myNodes,
///   theme: RoadmapTheme.darkTheme(),
///   onNodeTap: (node) => print('Tapped: ${node.id}'),
/// )
/// ```
///
/// ## Advanced Customization
/// ```dart
/// RoadmapViewer(
///   nodes: myNodes,
///   nodeStyleProvider: (node) {
///     if (node.progress == ProgressStatus.complete) {
///       return RoadmapNodeStyle(
///         borderColor: Colors.green,
///         borderWidth: 5,
///       );
///     }
///     return RoadmapNodeStyle.skillStyle();
///   },
///   nodeBuilder: (context, node) {
///     // Fully custom node widget
///     return MyCustomNodeWidget(node);
///   },
/// )
/// ```
class RoadmapViewer extends StatefulWidget {
  /// Creates a roadmap viewer.
  const RoadmapViewer({
    super.key,
    required this.nodes,
    this.width,
    this.height,
    this.courseLabel = '',
    this.edgeStyle = EdgeStyle.orthogonal,
    this.orientation = RoadmapOrientation.horizontal,
    this.nodeWidth = 120.0,
    this.nodeHeight = 60.0,
    this.horizontalSpacing = 100.0,
    this.verticalSpacing = 50.0,
    this.onNodeTap,
    this.showFitButton = true,
    this.minScale = 0.3,
    this.maxScale = 3.0,
    this.theme,
    this.nodeBuilder,
    this.nodeStyleProvider,
  });

  /// List of nodes to display in the roadmap.
  final List<RoadmapNode> nodes;

  /// Width of the viewer (defaults to screen width if null).
  final double? width;

  /// Height of the viewer (defaults to screen height if null).
  final double? height;

  /// Label to override for root course nodes.
  final String courseLabel;

  /// Style of edges connecting nodes.
  final EdgeStyle edgeStyle;

  /// Orientation of the roadmap layout.
  final RoadmapOrientation orientation;

  /// Width of individual nodes.
  ///
  /// Note: All nodes must have the same width for proper layout.
  final double nodeWidth;

  /// Height of individual nodes.
  ///
  /// Note: All nodes must have the same height for proper layout.
  final double nodeHeight;

  /// Horizontal spacing between nodes.
  final double horizontalSpacing;

  /// Vertical spacing between nodes.
  final double verticalSpacing;

  /// Callback when a node is tapped.
  final void Function(RoadmapNode node)? onNodeTap;

  /// Whether to show the fit-to-screen button.
  final bool showFitButton;

  /// Minimum zoom scale.
  final double minScale;

  /// Maximum zoom scale.
  final double maxScale;

  /// Theme configuration for colors and styling.
  final RoadmapTheme? theme;

  /// Custom builder for rendering nodes.
  ///
  /// If provided, this completely overrides default node rendering.
  /// You have full control over node appearance.
  ///
  /// Example:
  /// ```dart
  /// nodeBuilder: (context, node) {
  ///   return Container(
  ///     width: 150,
  ///     height: 80,
  ///     decoration: BoxDecoration(
  ///       color: Colors.blue,
  ///       borderRadius: BorderRadius.circular(8),
  ///     ),
  ///     child: Text(node.name ?? node.id),
  ///   );
  /// }
  /// ```
  final Widget Function(BuildContext context, RoadmapNode node)? nodeBuilder;

  /// Provider for node-specific styling.
  ///
  /// Allows different styles per node based on type, progress, or custom data.
  /// Only used if [nodeBuilder] is null.
  ///
  /// IMPORTANT: All styles should return the same width and height
  /// as [nodeWidth] and [nodeHeight] to avoid layout issues.
  ///
  /// Example:
  /// ```dart
  /// nodeStyleProvider: (node) {
  ///   if (node.nodeType == 'course') {
  ///     return RoadmapNodeStyle(
  ///       width: 120,  // Must match nodeWidth
  ///       height: 60,  // Must match nodeHeight
  ///       backgroundColor: Colors.blue.shade100,
  ///     );
  ///   }
  ///   return RoadmapNodeStyle.skillStyle();
  /// }
  /// ```
  final RoadmapNodeStyle Function(RoadmapNode node)? nodeStyleProvider;

  @override
  State<RoadmapViewer> createState() => _RoadmapViewerState();
}

class _RoadmapViewerState extends State<RoadmapViewer> {
  late TransformationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TransformationController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.nodes.isEmpty) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: const Center(
          child: Text('No roadmap data available'),
        ),
      );
    }

    final layoutEngine = ParentAwareLayoutEngine();
    final positions = layoutEngine.computePositions(
      widget.nodes,
      nodeWidth: widget.nodeWidth,
      nodeHeight: widget.nodeHeight,
      hSpacing: widget.horizontalSpacing,
      vSpacing: widget.verticalSpacing,
      orientation: widget.orientation,
    );

    final bounds = RoadmapLayoutUtils.computeBounds(
      positions,
      widget.nodeWidth,
      widget.nodeHeight,
    );

    final canvasWidth = bounds.width + widget.horizontalSpacing * 2;
    final canvasHeight = bounds.height + widget.verticalSpacing * 2;

    final media = MediaQuery.of(context);
    final paintWidth = math.max(canvasWidth, media.size.width);
    final paintHeight = math.max(canvasHeight, media.size.height);

    final centeredPositions = RoadmapLayoutUtils.centerPositions(
      positions,
      bounds,
      paintWidth,
      paintHeight,
    );

    final finalPositions = RoadmapLayoutUtils.collapseDuplicateLeaves(
      centeredPositions,
      widget.nodes,
    );

    final leafNodes = widget.nodes
        .where(
            (n) => n.nodeType.toLowerCase() == 'course' && n.childIds.isEmpty)
        .toList();
    final canonicalLeafId = leafNodes.isNotEmpty ? leafNodes.first.id : null;

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Stack(
        children: [
          InteractiveViewer(
            transformationController: _controller,
            constrained: false,
            boundaryMargin: EdgeInsets.zero,
            minScale: RoadmapLayoutUtils.computeMinScale(
              canvasWidth,
              canvasHeight,
              media.size.width,
              media.size.height,
            ).clamp(widget.minScale, 1.0),
            maxScale: widget.maxScale,
            child: Stack(
              children: [
                CustomPaint(
                  painter: BackgroundPainter(
                    widget.nodes,
                    orientation: widget.orientation,
                    theme: widget.theme,
                  ),
                  size: Size(paintWidth, paintHeight),
                ),
                CustomPaint(
                  painter: EdgePainter(
                    widget.nodes,
                    finalPositions,
                    nodeWidth: widget.nodeWidth,
                    nodeHeight: widget.nodeHeight,
                    style: widget.edgeStyle,
                    orientation: widget.orientation,
                    theme: widget.theme,
                  ),
                  size: Size(paintWidth, paintHeight),
                ),
                ...finalPositions.entries.map((entry) {
                  final node =
                      widget.nodes.firstWhere((n) => n.id == entry.key);
                  final pos = entry.value;

                  if (RoadmapLayoutUtils.shouldSkipDuplicateLeaf(
                    node,
                    leafNodes,
                    canonicalLeafId,
                  )) {
                    return const SizedBox.shrink();
                  }

                  return Positioned(
                    left: pos.x,
                    top: pos.y,
                    child: _buildNode(context, node),
                  );
                }),
              ],
            ),
          ),
          if (widget.showFitButton)
            RoadmapFitButton(
              onPressed: () => _fitToScreen(canvasWidth, canvasHeight),
              backgroundColor: Theme.of(context).primaryColor,
            ),
        ],
      ),
    );
  }

  Widget _buildNode(BuildContext context, RoadmapNode node) {
    // Use custom node builder if provided
    if (widget.nodeBuilder != null) {
      final customNode = widget.nodeBuilder!(context, node);
      if (widget.onNodeTap != null) {
        return GestureDetector(
          onTap: () => widget.onNodeTap!(node),
          child: customNode,
        );
      }
      return customNode;
    }

    // Use style provider if available
    final style = widget.nodeStyleProvider?.call(node);

    // Fallback to layer-based colors
    final scheme = Theme.of(context).colorScheme;
    final effectiveStyle = style ??
        RoadmapNodeStyle(
          width: widget.nodeWidth,
          height: widget.nodeHeight,
          backgroundColor: RoadmapColorUtils.layerFillColor(
            node.layer,
            scheme,
            theme: widget.theme,
          ),
          borderColor: RoadmapColorUtils.layerBorderColor(
            node.layer,
            scheme,
            theme: widget.theme,
          ),
        );

    String? overrideLabel;
    if (node.nodeType.toLowerCase() == 'course' && node.parentIds.isEmpty) {
      overrideLabel = widget.courseLabel.isNotEmpty ? widget.courseLabel : null;
    }

    return RoadmapNodeWidget(
      node: node,
      style: effectiveStyle,
      overrideCourseLabel: overrideLabel,
      onTap: widget.onNodeTap != null ? () => widget.onNodeTap!(node) : null,
      theme: widget.theme, // PASS THEME HERE
    );
  }

  void _fitToScreen(double canvasWidth, double canvasHeight) {
    final screen = MediaQuery.of(context).size;
    final scale = RoadmapLayoutUtils.computeMinScale(
      canvasWidth,
      canvasHeight,
      screen.width,
      screen.height,
    );

    final dx = (screen.width - canvasWidth * scale) / 2;
    final dy = (screen.height - canvasHeight * scale) / 2;

    _controller.value = Matrix4.identity()
      ..translate(dx, dy)
      ..scale(scale);
  }
}
