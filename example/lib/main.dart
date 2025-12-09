import 'package:flutter/material.dart';
import 'package:flutter_roadmap_viewer/flutter_roadmap_viewer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Roadmap Viewer Demo',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: const RoadmapDemoPage(),
    );
  }
}

class RoadmapDemoPage extends StatefulWidget {
  const RoadmapDemoPage({super.key});

  @override
  State<RoadmapDemoPage> createState() => _RoadmapDemoPageState();
}

class _RoadmapDemoPageState extends State<RoadmapDemoPage> {
  EdgeStyle _edgeStyle = EdgeStyle.orthogonal;
  RoadmapOrientation _orientation = RoadmapOrientation.horizontal;
  RoadmapTheme? _theme;
  String? _tappedNodeId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Roadmap Viewer Demo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showSettings,
          ),
        ],
      ),
      body: Column(
        children: [
          if (_tappedNodeId != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Colors.blue.shade100,
              child: Text(
                'Last tapped: $_tappedNodeId',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          Expanded(
            child: RoadmapViewer(
              nodes: _createDemoNodes(),
              edgeStyle: _edgeStyle,
              orientation: _orientation,
              theme: _theme,
              onNodeTap: (node) {
                setState(() {
                  _tappedNodeId = node.name ?? node.id;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showSettings() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Settings',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Edge Style:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            SegmentedButton<EdgeStyle>(
              segments: const [
                ButtonSegment(
                  value: EdgeStyle.orthogonal,
                  label: Text('Orthogonal'),
                  icon: Icon(Icons.stairs),
                ),
                ButtonSegment(
                  value: EdgeStyle.curved,
                  label: Text('Curved'),
                  icon: Icon(Icons.waves),
                ),
              ],
              selected: {_edgeStyle},
              onSelectionChanged: (Set<EdgeStyle> newSelection) {
                setState(() {
                  _edgeStyle = newSelection.first;
                });
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Orientation:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            SegmentedButton<RoadmapOrientation>(
              segments: const [
                ButtonSegment(
                  value: RoadmapOrientation.horizontal,
                  label: Text('Horizontal'),
                  icon: Icon(Icons.arrow_forward),
                ),
                ButtonSegment(
                  value: RoadmapOrientation.vertical,
                  label: Text('Vertical'),
                  icon: Icon(Icons.arrow_downward),
                ),
              ],
              selected: {_orientation},
              onSelectionChanged: (Set<RoadmapOrientation> newSelection) {
                setState(() {
                  _orientation = newSelection.first;
                });
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 16),
            const Text('Theme:', style: TextStyle(fontWeight: FontWeight.w600)),
            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('Default'),
                  selected: _theme == null,
                  onSelected: (selected) {
                    setState(() => _theme = null);
                    Navigator.pop(context);
                  },
                ),
                ChoiceChip(
                  label: const Text('Dark'),
                  selected: _theme == RoadmapTheme.darkTheme(),
                  onSelected: (selected) {
                    setState(() => _theme = RoadmapTheme.darkTheme());
                    Navigator.pop(context);
                  },
                ),
                ChoiceChip(
                  label: const Text('Light'),
                  selected: _theme == RoadmapTheme.lightTheme(),
                  onSelected: (selected) {
                    setState(() => _theme = RoadmapTheme.lightTheme());
                    Navigator.pop(context);
                  },
                ),
                ChoiceChip(
                  label: const Text('Vibrant'),
                  selected: _theme == RoadmapTheme.vibrantTheme(),
                  onSelected: (selected) {
                    setState(() => _theme = RoadmapTheme.vibrantTheme());
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<RoadmapNode> _createDemoNodes() {
    return [
      const RoadmapNode(
        id: 'programming',
        name: 'Programming Fundamentals',
        nodeType: 'course',
        layer: 0,
        parentIds: [],
        childIds: ['variables', 'control-flow'],
        progress: ProgressStatus.complete,
      ),
      const RoadmapNode(
        id: 'variables',
        name: 'Variables & Data Types',
        nodeType: 'skill',
        layer: 1,
        parentIds: ['programming'],
        childIds: ['functions', 'oop'],
        progress: ProgressStatus.complete,
      ),
      const RoadmapNode(
        id: 'control-flow',
        name: 'Control Flow',
        nodeType: 'skill',
        layer: 1,
        parentIds: ['programming'],
        childIds: ['functions'],
        progress: ProgressStatus.complete,
      ),
      const RoadmapNode(
        id: 'functions',
        name: 'Functions',
        nodeType: 'skill',
        layer: 2,
        parentIds: ['variables', 'control-flow'],
        childIds: ['algorithms', 'data-structures'],
        progress: ProgressStatus.current,
      ),
      const RoadmapNode(
        id: 'oop',
        name: 'Object-Oriented Programming',
        nodeType: 'skill',
        layer: 2,
        parentIds: ['variables'],
        childIds: ['design-patterns'],
        progress: ProgressStatus.current,
      ),
      const RoadmapNode(
        id: 'algorithms',
        name: 'Algorithms',
        nodeType: 'skill',
        layer: 3,
        parentIds: ['functions'],
        childIds: ['problem-solving'],
        progress: ProgressStatus.notStarted,
      ),
      const RoadmapNode(
        id: 'data-structures',
        name: 'Data Structures',
        nodeType: 'skill',
        layer: 3,
        parentIds: ['functions'],
        childIds: ['problem-solving'],
        progress: ProgressStatus.notStarted,
      ),
      const RoadmapNode(
        id: 'design-patterns',
        name: 'Design Patterns',
        nodeType: 'skill',
        layer: 3,
        parentIds: ['oop'],
        childIds: ['software-architecture'],
        progress: ProgressStatus.skipped,
      ),
      const RoadmapNode(
        id: 'problem-solving',
        name: 'Problem Solving',
        nodeType: 'skill',
        layer: 4,
        parentIds: ['algorithms', 'data-structures'],
        childIds: ['advanced-course'],
        progress: ProgressStatus.notStarted,
      ),
      const RoadmapNode(
        id: 'software-architecture',
        name: 'Software Architecture',
        nodeType: 'skill',
        layer: 4,
        parentIds: ['design-patterns'],
        childIds: ['advanced-course'],
        progress: ProgressStatus.notStarted,
      ),
      const RoadmapNode(
        id: 'advanced-course',
        name: 'Advanced Programming',
        nodeType: 'course',
        layer: 5,
        parentIds: ['problem-solving', 'software-architecture'],
        childIds: [],
        progress: ProgressStatus.notStarted,
      ),
    ];
  }
}
