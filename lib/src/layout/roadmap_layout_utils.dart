import '../models/position_data.dart';
import '../models/bounds_data.dart';
import '../models/roadmap_node.dart';

/// Utility functions for roadmap layout calculations.
class RoadmapLayoutUtils {
  /// Computes the bounding box for all node positions.
  static BoundsData computeBounds(
    Map<String, PositionData> positions,
    double nodeWidth,
    double nodeHeight,
  ) {
    if (positions.isEmpty) return BoundsData.zero();

    var minX = double.infinity;
    var minY = double.infinity;
    var maxX = double.negativeInfinity;
    var maxY = double.negativeInfinity;

    for (final pos in positions.values) {
      if (pos.x < minX) minX = pos.x;
      if (pos.y < minY) minY = pos.y;
      if (pos.x > maxX) maxX = pos.x;
      if (pos.y > maxY) maxY = pos.y;
    }

    return BoundsData(minX, minY, maxX + nodeWidth, maxY + nodeHeight);
  }

  /// Computes the minimum scale to fit content in screen.
  static double computeMinScale(
    double canvasWidth,
    double canvasHeight,
    double screenWidth,
    double screenHeight,
  ) {
    final scaleX = screenWidth / canvasWidth;
    final scaleY = screenHeight / canvasHeight;
    return scaleX < scaleY ? scaleX : scaleY;
  }

  /// Centers all positions within the paint area.
  static Map<String, PositionData> centerPositions(
    Map<String, PositionData> positions,
    BoundsData bounds,
    double paintWidth,
    double paintHeight,
  ) {
    final centerOffsetX = (paintWidth - bounds.width) / 2 - bounds.left;
    final centerOffsetY = (paintHeight - bounds.height) / 2 - bounds.top;

    return <String, PositionData>{
      for (final entry in positions.entries)
        entry.key: PositionData(
          entry.value.x + centerOffsetX,
          entry.value.y + centerOffsetY,
        ),
    };
  }

  /// Collapses duplicate leaf nodes to the same position.
  static Map<String, PositionData> collapseDuplicateLeaves(
    Map<String, PositionData> positions,
    List<RoadmapNode> nodes,
  ) {
    final leafNodes = nodes
        .where(
            (n) => n.nodeType.toLowerCase() == 'course' && n.childIds.isEmpty)
        .toList();

    if (leafNodes.isEmpty || leafNodes.length <= 1) {
      return positions;
    }

    final canonicalLeafId = leafNodes.first.id;
    final canonicalPos = positions[canonicalLeafId];

    if (canonicalPos == null) return positions;

    final updatedPositions = Map<String, PositionData>.from(positions);
    for (final node in leafNodes) {
      if (node.id != canonicalLeafId) {
        updatedPositions[node.id] = canonicalPos;
      }
    }

    return updatedPositions;
  }

  /// Checks if a duplicate leaf node should be skipped in rendering.
  static bool shouldSkipDuplicateLeaf(
    RoadmapNode node,
    List<RoadmapNode> allLeafNodes,
    String? canonicalLeafId,
  ) {
    if (canonicalLeafId == null || allLeafNodes.length <= 1) {
      return false;
    }

    final isLeafCourse =
        node.nodeType.toLowerCase() == 'course' && node.childIds.isEmpty;

    return isLeafCourse && node.id != canonicalLeafId;
  }
}
