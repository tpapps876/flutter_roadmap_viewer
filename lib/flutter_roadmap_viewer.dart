/// A highly customizable roadmap and skill tree visualization widget.
///
/// This library provides an interactive roadmap viewer with support for
/// hierarchical node layouts, multiple orientations, progress tracking,
/// and customizable styling.
///
/// ## Features
///
/// - **Hierarchical Layout**: Parent-aware positioning algorithm
/// - **Interactive**: Pan, zoom, and tap interactions
/// - **Customizable**: Themes, styles, and custom node builders
/// - **Progress Tracking**: Visual progress indicators
/// - **Multiple Orientations**: Horizontal and vertical layouts
/// - **Edge Styles**: Curved or orthogonal connections
///
/// ## Basic Usage
///
/// ```dart
/// import 'package:flutter_roadmap_viewer/flutter_roadmap_viewer.dart';
///
/// RoadmapViewer(
///   nodes: [
///     RoadmapNode(
///       id: 'flutter',
///       name: 'Flutter Basics',
///       nodeType: 'skill',
///       layer: 0,
///       parentIds: [],
///       childIds: ['widgets', 'state'],
///       progressPercent: 75,
///     ),
///     // ... more nodes
///   ],
///   onNodeTap: (node) {
///     print('Tapped: ${node.name}');
///   },
/// )
/// ```
///
/// ## Advanced Customization
///
/// ```dart
/// RoadmapViewer(
///   nodes: myNodes,
///   theme: RoadmapTheme.darkTheme(),
///   nodeStyleProvider: (node) {
///     if (node.customData?['priority'] == 'high') {
///       return RoadmapNodeStyle(
///         borderColor: Colors.red,
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
library flutter_roadmap_viewer;

// Export models
export 'src/models/position_data.dart';
export 'src/models/bounds_data.dart';
export 'src/models/roadmap_node.dart';
export 'src/models/roadmap_enums.dart';
export 'src/models/progress_status.dart';
export 'src/models/roadmap_node_style.dart';
export 'src/models/roadmap_theme.dart';

// Export layout classes
export 'src/layout/parent_aware_layout_engine.dart';
export 'src/layout/roadmap_layout_utils.dart';

// Export painters
export 'src/painters/background_painter.dart';
export 'src/painters/edge_painter.dart';

// Export utilities
export 'src/utils/roadmap_color_utils.dart';

// Export widgets
export 'src/widgets/roadmap_node_widget.dart';
export 'src/widgets/roadmap_fit_button.dart';
export 'src/widgets/roadmap_viewer.dart';
