/// Represents a 2D position with x and y coordinates.
class PositionData {
  /// The x coordinate.
  final double x;

  /// The y coordinate.
  final double y;

  /// Creates a position with the given coordinates.
  const PositionData(this.x, this.y);

  /// Adds two positions together.
  PositionData operator +(PositionData other) {
    return PositionData(x + other.x, y + other.y);
  }

  /// Subtracts one position from another.
  PositionData operator -(PositionData other) {
    return PositionData(x - other.x, y - other.y);
  }

  /// Multiplies the position by a scalar factor.
  PositionData operator *(double factor) {
    return PositionData(x * factor, y * factor);
  }

  @override
  String toString() => 'PositionData($x, $y)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PositionData &&
          runtimeType == other.runtimeType &&
          x == other.x &&
          y == other.y;

  @override
  int get hashCode => x.hashCode ^ y.hashCode;
}
