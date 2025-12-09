/// Orientation for roadmap layout.
enum RoadmapOrientation {
  /// Nodes flow left to right (traditional tree layout).
  horizontal,

  /// Nodes flow top to bottom.
  vertical,
}

/// Style for edges connecting nodes.
enum EdgeStyle {
  /// Smooth bezier curves between nodes.
  curved,

  /// Right-angle orthogonal lines between nodes.
  orthogonal,
}
