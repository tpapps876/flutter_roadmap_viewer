/// Represents a rectangular boundary with left, top, right, and bottom edges.
class BoundsData {
  /// The left edge coordinate.
  final double left;

  /// The top edge coordinate.
  final double top;

  /// The right edge coordinate.
  final double right;

  /// The bottom edge coordinate.
  final double bottom;

  /// Creates bounds with the given edge coordinates.
  const BoundsData(this.left, this.top, this.right, this.bottom);

  /// The width of the bounds.
  double get width => right - left;

  /// The height of the bounds.
  double get height => bottom - top;

  /// Returns bounds with all edges at zero.
  static BoundsData zero() {
    return const BoundsData(0, 0, 0, 0);
  }

  @override
  String toString() =>
      'BoundsData(left: $left, top: $top, right: $right, bottom: $bottom)';
}
