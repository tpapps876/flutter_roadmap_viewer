# Flutter Roadmap Viewer

A highly customizable roadmap and skill tree visualization widget for Flutter with interactive pan/zoom, multiple layout orientations, and progress tracking.

## Features

- Hierarchical Layout - Parent-aware positioning algorithm that visually represents dependencies
- Customizable Themes - Pre-built themes (default, dark, light, vibrant) or create your own
- Interactive - Pan, zoom, and tap interactions with fit-to-screen button
- Progress Tracking - Four status types: Not Started, Current, Complete, Skipped
- Multiple Orientations - Horizontal (traditional) or vertical layouts
- Edge Styles - Curved bezier or orthogonal (right-angle) connections
- Custom Rendering - Full control with custom node builders and style providers
- JSON Support - Easy serialization with legacy format migration

## Installation

Add to your pubspec.yaml:
```yamldependencies:
flutter_roadmap_viewer: ^0.1.0

Then run:
```bashflutter pub get

## Quick Start
```dartimport 'package:flutter_roadmap_viewer/flutter_roadmap_viewer.dart';final nodes = [
RoadmapNode(
id: 'flutter-basics',
name: 'Flutter Basics',
nodeType: 'skill',
layer: 0,
parentIds: [],
childIds: ['widgets', 'state'],
progress: ProgressStatus.complete,
),
RoadmapNode(
id: 'widgets',
name: 'Widgets',
nodeType: 'skill',
layer: 1,
parentIds: ['flutter-basics'],
childIds: [],
progress: ProgressStatus.current,
),
RoadmapNode(
id: 'state',
name: 'State Management',
nodeType: 'skill',
layer: 1,
parentIds: ['flutter-basics'],
childIds: [],
progress: ProgressStatus.notStarted,
),
];RoadmapViewer(
nodes: nodes,
onNodeTap: (node) => print('Tapped: ${node.name}'),
)

## Usage Examples

### With Dark Theme
```dartRoadmapViewer(
nodes: myNodes,
theme: RoadmapTheme.darkTheme(),
edgeStyle: EdgeStyle.curved,
)

### With Custom Theme
```dartRoadmapViewer(
nodes: myNodes,
theme: const RoadmapTheme(
completeNodeColor: Color(0xFF00C853),
currentNodeColor: Color(0xFF2979FF),
notStartedNodeColor: Color(0xFF546E7A),
skippedNodeColor: Color(0xFFFF6D00),
backgroundColor: Colors.white,
edgeWidth: 4.0,
),
)

### With Vertical Orientation
```dartRoadmapViewer(
nodes: myNodes,
orientation: RoadmapOrientation.vertical,
edgeStyle: EdgeStyle.curved,
)

### With Custom Node Styling
```dartRoadmapViewer(
nodes: myNodes,
nodeStyleProvider: (node) {
if (node.progress == ProgressStatus.complete) {
return RoadmapNodeStyle(
width: 150,
height: 70,
borderColor: Colors.green,
borderWidth: 5,
backgroundColor: Colors.green.withOpacity(0.1),
);
}
return RoadmapNodeStyle.skillStyle();
},
)

### With Fully Custom Nodes
```dartRoadmapViewer(
nodes: myNodes,
nodeBuilder: (context, node) {
return Container(
width: 160,
height: 80,
decoration: BoxDecoration(
gradient: LinearGradient(
colors: [Colors.blue, Colors.purple],
),
borderRadius: BorderRadius.circular(16),
),
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
Icon(Icons.star, color: Colors.white),
SizedBox(height: 4),
Text(
node.name ?? node.id,
style: TextStyle(color: Colors.white),
),
],
),
);
},
)

### With Custom Data
```dartfinal nodes = [
RoadmapNode(
id: 'python',
name: 'Python Programming',
nodeType: 'skill',
layer: 0,
parentIds: [],
childIds: [],
progress: ProgressStatus.complete,
customData: {
'difficulty': 'beginner',
'estimatedHours': 40,
'icon': 'assets/python.png',
'tags': ['programming', 'backend'],
},
),
];RoadmapViewer(
nodes: nodes,
nodeBuilder: (context, node) {
final difficulty = node.customData?['difficulty'] ?? 'unknown';
final hours = node.customData?['estimatedHours'] ?? 0;return MyCustomWidget(
  title: node.name,
  difficulty: difficulty,
  hours: hours,
);
},
)

## JSON Serialization

### Standard Format
```dart// Serialize
final json = node.toJson();// Deserialize
final node = RoadmapNode.fromJson(json);

### Legacy Format Support

If you have existing data with progressPercent (0-100):
```dartfinal json = {
'id': 'node-1',
'nodeType': 'skill',
'layer': 0,
'parentIds': [],
'childIds': [],
'progressPercent': 85,
};final node = RoadmapNode.fromJsonLegacy(json);
print(node.progress); // ProgressStatus.complete

Conversion rules:
- 80-100 → ProgressStatus.complete
- 1-79 → ProgressStatus.current
- 0 → ProgressStatus.notStarted

## API Reference

### RoadmapViewer

Main widget for displaying roadmaps.

Required Parameters:
- nodes: List<RoadmapNode> - List of nodes to display

Optional Parameters:
- width: double? - Widget width (defaults to screen width)
- height: double? - Widget height (defaults to screen height)
- courseLabel: String - Override label for root course nodes
- edgeStyle: EdgeStyle - Edge connection style (default: orthogonal)
- orientation: RoadmapOrientation - Layout direction (default: horizontal)
- nodeWidth: double - Width of nodes (default: 120)
- nodeHeight: double - Height of nodes (default: 60)
- horizontalSpacing: double - Space between nodes horizontally (default: 100)
- verticalSpacing: double - Space between nodes vertically (default: 50)
- onNodeTap: Function(RoadmapNode)? - Callback when node is tapped
- showFitButton: bool - Show fit-to-screen button (default: true)
- minScale: double - Minimum zoom level (default: 0.3)
- maxScale: double - Maximum zoom level (default: 3.0)
- theme: RoadmapTheme? - Theme configuration
- nodeBuilder: Widget Function(BuildContext, RoadmapNode)? - Custom node builder
- nodeStyleProvider: RoadmapNodeStyle Function(RoadmapNode)? - Node style provider

### RoadmapNode

Represents a single node in the roadmap.

Required Fields:
- id: String - Unique identifier
- nodeType: String - Type of node (e.g., 'skill', 'course')
- layer: int - Hierarchy level (0 = root)
- parentIds: List<String> - Parent node IDs
- childIds: List<String> - Child node IDs

Optional Fields:
- name: String? - Display name (defaults to id)
- progress: ProgressStatus - Progress status (default: notStarted)
- customData: Map<String, dynamic>? - Custom metadata

### ProgressStatus

Enum representing node progress:
- ProgressStatus.notStarted - Not yet started
- ProgressStatus.current - Currently in progress
- ProgressStatus.complete - Completed
- ProgressStatus.skipped - Skipped or not applicable

### RoadmapTheme

Theme configuration for the roadmap.

Pre-built Themes:
- RoadmapTheme.defaultTheme - Soft blue-mint gradient
- RoadmapTheme.darkTheme() - Dark background with muted colors
- RoadmapTheme.lightTheme() - White background with bright colors
- RoadmapTheme.vibrantTheme() - Bold, saturated colors

### RoadmapNodeStyle

Style configuration for individual nodes.

Pre-built Styles:
- RoadmapNodeStyle.defaultStyle - Standard style with shadows
- RoadmapNodeStyle.courseStyle() - Pill-shaped (150x70)
- RoadmapNodeStyle.skillStyle() - Rounded rectangle (120x60)

## Layout Algorithm

The package uses a parent-aware layout engine that:
1. Groups nodes by layer
2. Places root nodes in a grid
3. Positions children by averaging parent positions
4. Resolves collisions by spreading overlapping nodes
5. Centers content within the canvas

Note: Currently all nodes must have the same dimensions for proper layout.

## Best Practices

### Node Sizing
All nodes should use consistent dimensions:
```dartRoadmapViewer(
nodes: nodes,
nodeWidth: 120,
nodeHeight: 60,
nodeStyleProvider: (node) {
return RoadmapNodeStyle(
width: 120,  // Same as nodeWidth
height: 60,  // Same as nodeHeight
);
},
)

### Large Roadmaps
For roadmaps with 50+ nodes:
- Use smaller node sizes
- Increase spacing
- Provide search/filter functionality
- Consider breaking into multiple views

### Performance
- Avoid rebuilding the entire node list frequently
- Use const constructors where possible
- Consider caching node positions for static roadmaps

## Migration from Legacy Format

If you have data with progressPercent:
```dartfinal oldNodes = jsonData.map((json) => {
'id': json['id'],
'progressPercent': json['progressPercent'],
});final newNodes = oldNodes.map((json) =>
RoadmapNode.fromJsonLegacy(json)
).toList();

## Troubleshooting

### Nodes Not Appearing
- Check that all node IDs are unique
- Verify parent/child relationships are valid
- Ensure layer numbers are consecutive

### Layout Issues
- Confirm all nodes have the same width/height
- Check that nodeStyleProvider returns consistent dimensions
- Verify spacing values are reasonable

### Theme Not Applying
- Ensure theme is passed to RoadmapViewer
- Check that theme colors are opaque
- Verify custom node builders aren't overriding theme colors

## Examples

See the example directory for a complete demo app showing:
- Basic roadmap
- Multiple themes
- Custom styling
- Different orientations
- Interactive features

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Changelog

See CHANGELOG.md for version history.