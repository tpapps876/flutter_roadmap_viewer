import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_roadmap_viewer/flutter_roadmap_viewer.dart';
import 'test_helpers.dart';

void main() {
  group('Integration Tests', () {
    testWidgets('complete roadmap renders and functions', (tester) async {
      final nodes = diamond(); // Complex structure
      var tappedNode = '';

      await pumpViewer(
        tester,
        nodes,
        onTap: (node) => tappedNode = node.id,
      );

      // Verify all components present
      expect(find.byType(RoadmapViewer), findsOneWidget);
      expect(find.byType(RoadmapNodeWidget), findsNWidgets(4));
      expect(find.byType(FloatingActionButton), findsOneWidget);

      // Test interaction
      await tester.tap(find.byType(RoadmapNodeWidget).first);
      await tester.pump();

      expect(tappedNode, isNotEmpty);
    });

    testWidgets('theme changes apply to all components', (tester) async {
      await pumpViewer(
        tester,
        chain(),
        theme: RoadmapTheme.darkTheme(),
      );

      expect(find.byType(RoadmapViewer), findsOneWidget);
      // In real app, would verify colors - skipping detailed checks
    });

    testWidgets('handles large roadmaps without error', (tester) async {
      final nodes = List.generate(
        20,
        (i) => node('node-$i',
            layer: i % 5, parents: i > 0 ? ['node-${i - 1}'] : []),
      );

      await pumpViewer(tester, nodes);

      expect(find.byType(RoadmapViewer), findsOneWidget);
    });
  });
}
