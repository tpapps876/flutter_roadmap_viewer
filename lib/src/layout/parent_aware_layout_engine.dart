import '../models/position_data.dart';
import '../models/roadmap_node.dart';
import '../models/roadmap_enums.dart';

/// Computes node positions using parent-aware layout algorithm.
///
/// This engine places nodes based on their parent positions, creating
/// a hierarchical layout that visually represents dependencies.
class ParentAwareLayoutEngine {
  /// Computes positions for all nodes in the roadmap.
  ///
  /// Returns a map of node IDs to their computed positions.
  Map<String, PositionData> computePositions(
    List<RoadmapNode> nodes, {
    double nodeWidth = 120,
    double nodeHeight = 60,
    double hSpacing = 100,
    double vSpacing = 50,
    RoadmapOrientation orientation = RoadmapOrientation.horizontal,
  }) {
    final positions = <String, PositionData>{};
    final layers = <int, List<RoadmapNode>>{};

    // Group nodes by layer
    for (final node in nodes) {
      layers.putIfAbsent(node.layer, () => []).add(node);
    }

    final isHorizontal = orientation == RoadmapOrientation.horizontal;

    // Place nodes layer by layer
    for (final entry in layers.entries) {
      final layer = entry.key;
      final nodesInLayer = entry.value;

      for (var i = 0; i < nodesInLayer.length; i++) {
        final node = nodesInLayer[i];

        if (node.parentIds.isEmpty) {
          // Root node - simple grid placement
          if (isHorizontal) {
            final y = i * (nodeHeight + vSpacing);
            positions[node.id] =
                PositionData(layer * (nodeWidth + hSpacing), y);
          } else {
            final x = i * (nodeWidth + hSpacing);
            positions[node.id] =
                PositionData(x, layer * (nodeHeight + vSpacing));
          }
        } else {
          // Child node - average parent positions
          if (isHorizontal) {
            final parentYs = node.parentIds
                .where((p) => positions.containsKey(p))
                .map((p) => positions[p]!.y)
                .toList();

            final avgY = parentYs.isNotEmpty
                ? parentYs.reduce((a, b) => a + b) / parentYs.length
                : i * (nodeHeight + vSpacing);

            positions[node.id] =
                PositionData(layer * (nodeWidth + hSpacing), avgY);
          } else {
            final parentXs = node.parentIds
                .where((p) => positions.containsKey(p))
                .map((p) => positions[p]!.x)
                .toList();

            final avgX = parentXs.isNotEmpty
                ? parentXs.reduce((a, b) => a + b) / parentXs.length
                : i * (nodeWidth + hSpacing);

            positions[node.id] =
                PositionData(avgX, layer * (nodeHeight + vSpacing));
          }
        }
      }

      // Resolve collisions within layer
      _resolveCollisions(
        positions,
        nodesInLayer,
        isHorizontal,
        nodeWidth,
        nodeHeight,
        hSpacing,
        vSpacing,
      );
    }

    return positions;
  }

  void _resolveCollisions(
    Map<String, PositionData> positions,
    List<RoadmapNode> nodesInLayer,
    bool isHorizontal,
    double nodeWidth,
    double nodeHeight,
    double hSpacing,
    double vSpacing,
  ) {
    if (!isHorizontal) {
      // Vertical: spread nodes horizontally when they overlap
      final byAnchorX = <double, List<String>>{};
      for (final node in nodesInLayer) {
        final pos = positions[node.id];
        if (pos == null) continue;
        final key = double.parse(pos.x.toStringAsFixed(1));
        byAnchorX.putIfAbsent(key, () => <String>[]).add(node.id);
      }

      byAnchorX.forEach((anchorKey, ids) {
        if (ids.length <= 1) return;
        final anchor = positions[ids.first]!.x;
        final mid = (ids.length - 1) / 2.0;
        for (var j = 0; j < ids.length; j++) {
          final id = ids[j];
          final old = positions[id]!;
          final newX = anchor + (j - mid) * (nodeWidth + hSpacing);
          positions[id] = PositionData(newX, old.y);
        }
      });

      // Ensure minimum spacing
      final idsInLayer = nodesInLayer.map((n) => n.id).toList();
      idsInLayer.sort((a, b) => positions[a]!.x.compareTo(positions[b]!.x));
      final minSpacing = nodeWidth + hSpacing;
      for (var k = 1; k < idsInLayer.length; k++) {
        final prevId = idsInLayer[k - 1];
        final curId = idsInLayer[k];
        final prev = positions[prevId]!;
        final cur = positions[curId]!;
        final delta = cur.x - prev.x;
        if (delta < minSpacing) {
          final shift = minSpacing - delta;
          positions[curId] = PositionData(cur.x + shift, cur.y);
        }
      }
    } else {
      // Horizontal: spread nodes vertically when they overlap
      final byAnchorY = <double, List<String>>{};
      for (final node in nodesInLayer) {
        final pos = positions[node.id];
        if (pos == null) continue;
        final key = double.parse(pos.y.toStringAsFixed(1));
        byAnchorY.putIfAbsent(key, () => <String>[]).add(node.id);
      }

      byAnchorY.forEach((anchorKey, ids) {
        if (ids.length <= 1) return;
        final anchor = positions[ids.first]!.y;
        final mid = (ids.length - 1) / 2.0;
        for (var j = 0; j < ids.length; j++) {
          final id = ids[j];
          final old = positions[id]!;
          final newY = anchor + (j - mid) * (nodeHeight + vSpacing);
          positions[id] = PositionData(old.x, newY);
        }
      });

      // Ensure minimum spacing
      final idsInLayer = nodesInLayer.map((n) => n.id).toList();
      idsInLayer.sort((a, b) => positions[a]!.y.compareTo(positions[b]!.y));
      final minSpacing = nodeHeight + 16;
      for (var k = 1; k < idsInLayer.length; k++) {
        final prevId = idsInLayer[k - 1];
        final curId = idsInLayer[k];
        final prev = positions[prevId]!;
        final cur = positions[curId]!;
        final delta = cur.y - prev.y;
        if (delta < minSpacing) {
          final shift = minSpacing - delta;
          positions[curId] = PositionData(cur.x, cur.y + shift);
        }
      }
    }
  }
}
