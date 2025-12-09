import 'progress_status.dart';

/// Represents a node in the roadmap (skill, course, or milestone).
class RoadmapNode {
  /// Unique identifier for this node.
  final String id;

  /// Display name for this node (if null, uses [id]).
  final String? name;

  /// Type of node (e.g., 'skill', 'course', 'milestone').
  final String nodeType;

  /// Layer/level in the roadmap hierarchy (0 = root).
  final int layer;

  /// IDs of parent nodes that this node depends on.
  final List<String> parentIds;

  /// IDs of child nodes that depend on this node.
  final List<String> childIds;

  /// Progress status of this node.
  final ProgressStatus progress;

  /// Custom data that users can attach to nodes.
  /// Use this to store additional information like icons, tags, metadata, etc.
  final Map<String, dynamic>? customData;

  /// Creates a roadmap node.
  const RoadmapNode({
    required this.id,
    this.name,
    required this.nodeType,
    required this.layer,
    required this.parentIds,
    required this.childIds,
    this.progress = ProgressStatus.notStarted,
    this.customData,
  });

  /// Creates a RoadmapNode from JSON.
  factory RoadmapNode.fromJson(Map<String, dynamic> json) {
    return RoadmapNode(
      id: json['id'] as String,
      name: json['name'] as String?,
      nodeType: json['nodeType'] as String,
      layer: json['layer'] as int,
      parentIds: (json['parentIds'] as List<dynamic>).cast<String>(),
      childIds: (json['childIds'] as List<dynamic>).cast<String>(),
      progress: json['progress'] != null
          ? ProgressStatus.fromString(json['progress'] as String)
          : ProgressStatus.notStarted,
      customData: json['customData'] as Map<String, dynamic>?,
    );
  }

  /// Creates a RoadmapNode from JSON with legacy progressPercent support.
  ///
  /// This factory supports both:
  /// - New format: `{ "progress": "complete" }`
  /// - Legacy format: `{ "progressPercent": 100 }`
  ///
  /// Use this when migrating from older data formats.
  factory RoadmapNode.fromJsonLegacy(Map<String, dynamic> json) {
    ProgressStatus progress;

    if (json.containsKey('progress')) {
      progress = ProgressStatus.fromString(json['progress'] as String);
    } else if (json.containsKey('progressPercent')) {
      final percent = json['progressPercent'] as int;
      if (percent >= 80) {
        progress = ProgressStatus.complete;
      } else if (percent >= 50) {
        progress = ProgressStatus.current;
      } else if (percent > 0) {
        progress = ProgressStatus.current;
      } else {
        progress = ProgressStatus.notStarted;
      }
    } else {
      progress = ProgressStatus.notStarted;
    }

    return RoadmapNode(
      id: json['id'] as String,
      name: json['name'] as String?,
      nodeType: json['nodeType'] as String,
      layer: json['layer'] as int,
      parentIds: (json['parentIds'] as List<dynamic>).cast<String>(),
      childIds: (json['childIds'] as List<dynamic>).cast<String>(),
      progress: progress,
      customData: json['customData'] as Map<String, dynamic>?,
    );
  }

  /// Converts this RoadmapNode to JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nodeType': nodeType,
      'layer': layer,
      'parentIds': parentIds,
      'childIds': childIds,
      'progress': progress.toJsonString(),
      if (customData != null) 'customData': customData,
    };
  }

  /// Creates a copy of this node with some fields replaced.
  RoadmapNode copyWith({
    String? id,
    String? name,
    String? nodeType,
    int? layer,
    List<String>? parentIds,
    List<String>? childIds,
    ProgressStatus? progress,
    Map<String, dynamic>? customData,
  }) {
    return RoadmapNode(
      id: id ?? this.id,
      name: name ?? this.name,
      nodeType: nodeType ?? this.nodeType,
      layer: layer ?? this.layer,
      parentIds: parentIds ?? this.parentIds,
      childIds: childIds ?? this.childIds,
      progress: progress ?? this.progress,
      customData: customData ?? this.customData,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoadmapNode &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'RoadmapNode(id: $id, name: $name, layer: $layer, progress: ${progress.label})';
}
