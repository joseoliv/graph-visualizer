# Graph Ring Visualizer

A Flutter application for creating, visualizing, and editing graph structures with interactive rings and arrows.

## Features

- **Interactive Graph Builder**: Create graphs with up to 19 vertices
- **Draggable Rings**: Position rings anywhere in the canvas
- **Color Customization**: Long-press any ring to change its color
- **Directed Connections**: Double-tap rings to create directed edges
- **Smart Arrow Routing**: Bidirectional connections automatically curve to avoid overlap
- **Real-time Updates**: Graph data structure updates with every interaction

## Data Structure

The application uses a `GraphRing` class that efficiently manages:
- **RingNode**: Individual nodes with position, color, and ID
- **DirectedEdge**: Directed connections between nodes
- **Position tracking**: Real-time coordinate updates
- **Edge management**: Add, remove, and query connections

## Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Android Studio / Xcode / VS Code

### Installation

1. Clone or download this project
2. Navigate to the project directory:
   ```bash
   cd graph_visualizer
   ```

3. Get dependencies:
   ```bash
   flutter pub get
   ```

4. Run the application:
   ```bash
   flutter run
   ```

## Usage

### Creating a Graph

1. **Set Number of Vertices**: Enter a number (1-19) in the left panel and click "Update Graph"
2. **Rings Appear**: Rings will be automatically distributed in the canvas

### Interacting with Rings

- **Drag to Move**: Click and drag any ring to reposition it
- **Change Color**: Long-press a ring and select a color from the picker
- **Create Connections**: 
  1. Double-tap the first ring (it will be highlighted)
  2. Double-tap the second ring to create a directed arrow
- **Clear Graph**: Click "Clear Graph" to reset everything

### Visual Features

- **Arrows**: Directed edges with arrowheads
- **Curved Connections**: Bidirectional edges automatically curve 30 degrees
- **Color Coding**: Each ring can have a different color
- **Selection Highlight**: Selected rings glow with their color

## Architecture

### Main Components

- **`GraphRing`**: Core data structure managing nodes and edges
- **`RingWidget`**: Draggable ring component with gesture handling
- **`GraphPainter`**: Custom painter for drawing arrows and connections
- **`ControlPanel`**: Left-side interface for graph configuration
- **`GraphScreen`**: Main screen coordinating all components

### Key Features Implementation

- **Drag & Drop**: GestureDetector with pan events
- **Color Picker**: Modal dialog with color grid
- **Double-tap Logic**: State management for connection creation
- **Arrow Drawing**: Custom canvas painting with quadratic Bezier curves
- **Edge Detection**: Efficient lookup for bidirectional connections

## Technical Details

### Dependencies

- `flutter`: Core Flutter framework
- `cupertino_icons`: iOS-style icons

### File Structure

```
lib/
├── main.dart              # App entry point
├── models/
│   └── graph_ring.dart    # Data structures
├── widgets/
│   ├── control_panel.dart # Left panel UI
│   ├── graph_painter.dart # Arrow rendering
│   └── ring_widget.dart   # Ring component
└── screens/
    └── graph_screen.dart  # Main app screen
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is open source and available under the MIT License.

## Troubleshooting

### Common Issues

- **Build Errors**: Run `flutter clean` then `flutter pub get`
- **Performance**: Limit vertex count to maintain smooth interactions
- **Gesture Conflicts**: Ensure proper gesture detector priorities

### Platform Support

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Windows
- ✅ macOS
- ✅ Linux

## Future Enhancements

- Export/import graph data
- Additional graph algorithms (shortest path, etc.)
- Ring size customization
- Arrow style options
- Graph layout algorithms (force-directed, circular, etc.)