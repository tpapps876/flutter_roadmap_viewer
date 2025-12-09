import 'package:flutter/material.dart';

/// A floating button that resets the roadmap zoom to fit the screen.
class RoadmapFitButton extends StatelessWidget {
  /// Creates a fit button.
  const RoadmapFitButton({
    super.key,
    required this.onPressed,
    required this.backgroundColor,
  });

  /// Callback when button is pressed.
  final VoidCallback onPressed;

  /// Background color of the button.
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 16,
      right: 16,
      child: FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: backgroundColor,
        child: const Icon(Icons.fit_screen, color: Colors.white),
      ),
    );
  }
}
