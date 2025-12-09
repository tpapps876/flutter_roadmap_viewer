# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2025-01-XX

### Added
- Initial release of flutter_roadmap_viewer
- `RoadmapViewer` widget with interactive pan/zoom
- `RoadmapNode` model with JSON serialization
- `ProgressStatus` enum (notStarted, current, complete, skipped)
- Parent-aware layout engine with collision detection
- Multiple layout orientations (horizontal, vertical)
- Multiple edge styles (curved, orthogonal)
- Customizable themes with 4 pre-built options:
  - Default theme (soft gradients)
  - Dark theme
  - Light theme
  - Vibrant theme
- `RoadmapNodeStyle` for per-node styling
- Custom node builder support
- Node style provider support
- Fit-to-screen button
- Custom data support on nodes
- Legacy `progressPercent` migration via `fromJsonLegacy()`

### Features
- Interactive gestures (pan, zoom, tap)
- Progress-based node coloring
- Layer-based color cycling
- Duplicate leaf node collapsing
- Configurable node dimensions and spacing
- Customizable edge width and colors
- Shadow support on nodes
- Custom text styling
- Background gradient or solid color support

### Documentation
- Comprehensive README with examples
- API reference documentation
- Migration guide for legacy data
- Best practices and troubleshooting

### Testing
- Unit tests for models, layout, and utilities
- Widget smoke tests
- Integration tests
- ~30 test cases covering critical paths

## [Unreleased]

### Planned
- Variable node sizes support
- Animation support for state changes
- Node search and filtering
- Minimap for large roadmaps
- Export to image functionality
- More edge routing algorithms
- Accessibility improvements