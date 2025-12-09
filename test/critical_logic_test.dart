import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_roadmap_viewer/flutter_roadmap_viewer.dart';
import 'test_helpers.dart';

void main() {
  group('Critical Logic Tests', () {
    group('Layout Engine', () {
      test('places root nodes correctly', () {
        final nodes = [node('a', layer: 0), node('b', layer: 0)];
        final engine = ParentAwareLayoutEngine();

        final positions = engine.computePositions(nodes);

        expect(positions['a'], isNotNull);
        expect(positions['b'], isNotNull);
        expect(
            positions['a']!.y, isNot(positions['b']!.y)); // Should be separated
      });

      test('child nodes average parent positions', () {
        final nodes = diamond(); // A → B,C → D
        final engine = ParentAwareLayoutEngine();

        final positions = engine.computePositions(nodes);

        // D should be between B and C vertically
        final avgY = (positions['b']!.y + positions['c']!.y) / 2;
        expect(positions['d']!.y, closeTo(avgY, 10));
      });

      test('handles collision resolution', () {
        final nodes = [
          node('a', layer: 0, children: ['b', 'c', 'd']),
          node('b', layer: 1, parents: ['a']),
          node('c', layer: 1, parents: ['a']),
          node('d', layer: 1, parents: ['a']),
        ];
        final engine = ParentAwareLayoutEngine();

        final positions = engine.computePositions(nodes);

        // All three children should be spread out
        final yPositions = [
          positions['b']!.y,
          positions['c']!.y,
          positions['d']!.y,
        ]..sort();

        expect(yPositions[1] - yPositions[0], greaterThan(60)); // Min spacing
        expect(yPositions[2] - yPositions[1], greaterThan(60));
      });

      test('respects orientation', () {
        final nodes = chain();
        final engine = ParentAwareLayoutEngine();

        final hPos = engine.computePositions(
          nodes,
          orientation: RoadmapOrientation.horizontal,
        );
        final vPos = engine.computePositions(
          nodes,
          orientation: RoadmapOrientation.vertical,
        );

        // Horizontal: X increases, Y stable
        expect(hPos['c']!.x, greaterThan(hPos['a']!.x));

        // Vertical: Y increases, X stable
        expect(vPos['c']!.y, greaterThan(vPos['a']!.y));
      });
    });

    group('ProgressStatus Parsing', () {
      test('parses all standard formats', () {
        expect(
            ProgressStatus.fromString('notStarted'), ProgressStatus.notStarted);
        expect(ProgressStatus.fromString('current'), ProgressStatus.current);
        expect(ProgressStatus.fromString('complete'), ProgressStatus.complete);
        expect(ProgressStatus.fromString('skipped'), ProgressStatus.skipped);
      });

      test('handles legacy variations', () {
        expect(ProgressStatus.fromString('not_started'),
            ProgressStatus.notStarted);
        expect(ProgressStatus.fromString('inprogress'), ProgressStatus.current);
        expect(ProgressStatus.fromString('completed'), ProgressStatus.complete);
      });

      test('is case-insensitive', () {
        expect(ProgressStatus.fromString('COMPLETE'), ProgressStatus.complete);
        expect(ProgressStatus.fromString('Current'), ProgressStatus.current);
      });

      test('defaults gracefully for invalid input', () {
        expect(ProgressStatus.fromString('invalid'), ProgressStatus.notStarted);
        expect(ProgressStatus.fromString(''), ProgressStatus.notStarted);
      });
    });

    group('JSON Serialization', () {
      test('node roundtrips through JSON', () {
        final original = node(
          'test',
          name: 'Test',
          type: 'skill',
          layer: 1,
          parents: ['p1'],
          children: ['c1'],
          progress: ProgressStatus.complete,
        );

        final json = original.toJson();
        final parsed = RoadmapNode.fromJson(json);

        expect(parsed.id, original.id);
        expect(parsed.name, original.name);
        expect(parsed.progress, original.progress);
      });

      test('handles legacy progressPercent', () {
        final json = {
          'id': 'test',
          'nodeType': 'skill',
          'layer': 0,
          'parentIds': [],
          'childIds': [],
          'progressPercent': 100,
        };

        final parsed = RoadmapNode.fromJsonLegacy(json);

        expect(parsed.progress, ProgressStatus.complete);
      });

      test('legacy: 80+ → complete, 1-79 → current, 0 → notStarted', () {
        expect(
          RoadmapNode.fromJsonLegacy({
            'id': 'a',
            'nodeType': 'skill',
            'layer': 0,
            'parentIds': [],
            'childIds': [],
            'progressPercent': 85
          }).progress,
          ProgressStatus.complete,
        );

        expect(
          RoadmapNode.fromJsonLegacy({
            'id': 'a',
            'nodeType': 'skill',
            'layer': 0,
            'parentIds': [],
            'childIds': [],
            'progressPercent': 50
          }).progress,
          ProgressStatus.current,
        );
      });
    });

    group('Layout Utilities', () {
      test('computeBounds includes all nodes', () {
        final positions = {
          'a': const PositionData(10, 20),
          'b': const PositionData(150, 100),
        };

        final bounds = RoadmapLayoutUtils.computeBounds(positions, 120, 60);

        expect(bounds.left, 10);
        expect(bounds.right, 270); // 150 + 120
      });

      test('duplicate leaf collapse works', () {
        final nodes = [
          node('a', type: 'course', layer: 1),
          node('b', type: 'course', layer: 1),
        ];
        final positions = {
          'a': const PositionData(0, 0),
          'b': const PositionData(0, 100),
        };

        final collapsed = RoadmapLayoutUtils.collapseDuplicateLeaves(
          positions,
          nodes,
        );

        expect(collapsed['a'], collapsed['b']); // Same position
      });
    });
  });
}
