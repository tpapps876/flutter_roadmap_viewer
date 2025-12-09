import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_roadmap_viewer/flutter_roadmap_viewer.dart';

// =============================================================================
// NODE FACTORIES
// =============================================================================

/// Quick node factory with sensible defaults.
RoadmapNode node(
  String id, {
  String? name,
  String type = 'skill',
  int layer = 0,
  List<String> parents = const [],
  List<String> children = const [],
  ProgressStatus progress = ProgressStatus.notStarted,
  Map<String, dynamic>? data,
}) =>
    RoadmapNode(
      id: id,
      name: name ?? 'Node $id',
      nodeType: type,
      layer: layer,
      parentIds: parents,
      childIds: children,
      progress: progress,
      customData: data,
    );

/// Simple 3-node chain: A → B → C
List<RoadmapNode> chain() => [
      node('a', layer: 0, children: ['b']),
      node('b', layer: 1, parents: ['a'], children: ['c']),
      node('c', layer: 2, parents: ['b']),
    ];

/// Diamond pattern: A → B,C → D
List<RoadmapNode> diamond() => [
      node('a', layer: 0, children: ['b', 'c']),
      node('b', layer: 1, parents: ['a'], children: ['d']),
      node('c', layer: 1, parents: ['a'], children: ['d']),
      node('d', layer: 2, parents: ['b', 'c']),
    ];

// =============================================================================
// WIDGET HELPERS
// =============================================================================

/// Pumps widget with MaterialApp wrapper.
Future<void> pump(WidgetTester tester, Widget widget) async {
  await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));
}

/// Quick RoadmapViewer pump.
Future<void> pumpViewer(
  WidgetTester tester,
  List<RoadmapNode> nodes, {
  RoadmapTheme? theme,
  EdgeStyle? edgeStyle,
  Function(RoadmapNode)? onTap,
}) async {
  await pump(
    tester,
    RoadmapViewer(
      nodes: nodes,
      theme: theme,
      edgeStyle: edgeStyle ?? EdgeStyle.orthogonal,
      onNodeTap: onTap,
    ),
  );
}

// =============================================================================
// MATCHERS
// =============================================================================

/// Matcher for PositionData equality.
Matcher isPosition(double x, double y, {double epsilon = 0.1}) {
  return predicate<PositionData>(
    (pos) => (pos.x - x).abs() < epsilon && (pos.y - y).abs() < epsilon,
    'is position ($x, $y)',
  );
}

/// Matcher for color equality by value.
Matcher isColor(int value) => predicate<Color>(
      (c) => c.toARGB32() == value,
      'is color 0x${value.toRadixString(16)}',
    );
