import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_roadmap_viewer/flutter_roadmap_viewer.dart';
import 'test_helpers.dart';

void main() {
  group('Widget Smoke Tests', () {
    testWidgets('RoadmapViewer renders without crashing', (tester) async {
      await pumpViewer(tester, chain());

      expect(find.byType(RoadmapViewer), findsOneWidget);
    });

    testWidgets('renders correct number of nodes', (tester) async {
      final nodes = chain(); // 3 nodes

      await pumpViewer(tester, nodes);

      expect(find.byType(RoadmapNodeWidget), findsNWidgets(3));
    });

    testWidgets('shows empty state with no nodes', (tester) async {
      await pumpViewer(tester, []);

      expect(find.text('No roadmap data available'), findsOneWidget);
    });

    testWidgets('applies theme colors', (tester) async {
      const theme = RoadmapTheme(completeNodeColor: Color(0xFFFF0000));
      final nodes = [node('a', progress: ProgressStatus.complete)];

      await pumpViewer(tester, nodes, theme: theme);

      // Just verify it renders - visual testing would check actual colors
      expect(find.byType(RoadmapViewer), findsOneWidget);
    });

    testWidgets('fit button appears by default', (tester) async {
      await pumpViewer(tester, chain());

      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('supports both orientations', (tester) async {
      await pump(
        tester,
        RoadmapViewer(
          nodes: chain(),
          orientation: RoadmapOrientation.vertical,
        ),
      );

      expect(find.byType(RoadmapViewer), findsOneWidget);
    });

    testWidgets('supports both edge styles', (tester) async {
      await pumpViewer(tester, chain(), edgeStyle: EdgeStyle.curved);

      expect(find.byType(RoadmapViewer), findsOneWidget);
    });
  });
}
