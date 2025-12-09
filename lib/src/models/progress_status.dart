/// Represents the progress status of a roadmap node.
enum ProgressStatus {
  /// Node has not been started yet.
  notStarted,

  /// Node is currently in progress.
  current,

  /// Node has been completed.
  complete,

  /// Node has been skipped or is not applicable.
  skipped;

  /// Creates a ProgressStatus from a string.
  static ProgressStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'notstarted':
      case 'not_started':
      case 'notStarted':
        return ProgressStatus.notStarted;
      case 'current':
      case 'inprogress':
      case 'in_progress':
        return ProgressStatus.current;
      case 'complete':
      case 'completed':
        return ProgressStatus.complete;
      case 'skipped':
        return ProgressStatus.skipped;
      default:
        return ProgressStatus.notStarted;
    }
  }

  /// Converts this ProgressStatus to a string.
  String toJsonString() {
    switch (this) {
      case ProgressStatus.notStarted:
        return 'notStarted';
      case ProgressStatus.current:
        return 'current';
      case ProgressStatus.complete:
        return 'complete';
      case ProgressStatus.skipped:
        return 'skipped';
    }
  }

  /// Returns a human-readable label for this status.
  String get label {
    switch (this) {
      case ProgressStatus.notStarted:
        return 'Not Started';
      case ProgressStatus.current:
        return 'In Progress';
      case ProgressStatus.complete:
        return 'Complete';
      case ProgressStatus.skipped:
        return 'Skipped';
    }
  }

  /// Returns whether this status indicates completion.
  bool get isCompleted => this == ProgressStatus.complete;

  /// Returns whether this status indicates active work.
  bool get isActive => this == ProgressStatus.current;

  /// Returns whether this status indicates no progress yet.
  bool get isNotStarted => this == ProgressStatus.notStarted;

  /// Returns whether this status indicates the node was skipped.
  bool get isSkipped => this == ProgressStatus.skipped;
}
