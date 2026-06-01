# OpenLayout

A Swift layout engine and declarative DSL inspired by SwiftUI's layout protocol. OpenLayout provides a full two-pass measurement and placement system that can be used independently of any specific rendering target.

## Overview

OpenLayout is organized into three libraries:

| Library | Description |
|---|---|
| **OpenLayout** | Core layout engine — `Layout` protocol, measurement, placement, node tree |
| **OpenLayoutDSL** | Declarative DSL — `HStack`, `VStack`, `padding`, `frame`, result builders |

## Requirements

- macOS 15+
- Swift 6.3+

## Usage

### OpenLayoutDSL

Compose layouts using a SwiftUI-like syntax:

```swift
import OpenLayoutDSL

let layout = HStack(alignment: .top) {
    VStack {
        Text("Hello")
        Text("World")
    }
    .padding(8)

    Spacer()

    Text("Trailing")
}
.frame(maxWidth: .infinity)
```

Available DSL components:

- **Stacks**: `HStack`, `VStack` with alignment and spacing
- **Sizing**: `frame(width:height:)`, `frame(minWidth:maxWidth:minHeight:maxHeight:alignment:)`
- **Spacing**: `padding(_:)`, `padding(edges:length:)`, `Spacer`
- **Decoration**: `background(_:)`, `FixedSize`

### Core Layout Protocol

Implement custom layouts by conforming to `Layout`:

```swift
import OpenLayout

struct MyLayout: Layout {
    func sizeThatFits(proposal: ProposedSize, node: LayoutNode) -> CGSize {
        // Measure and return the desired size
    }

    func placeChildren(in frame: CGRect, node: LayoutNode) {
        // Position children within the given frame
    }
}
```

For single-child layouts use `UnaryLayout`; for leaf nodes (no children) use `LeafLayout`.

## Building

```bash
swift build
swift test
```

## Architecture

OpenLayout uses a **two-pass layout system**:

1. **Measurement pass** (`sizeThatFits`) — each node reports its desired size given a size proposal. Proposals carry optional width and height, allowing flexible or fixed constraints.
2. **Placement pass** (`placeChildren`) — the parent positions each child within the allocated frame.

Results from the measurement pass are cached in `LayoutNode` to avoid redundant recalculation during placement.

Stack layouts use a **priority-based space distribution** algorithm: children are grouped by layout priority and higher-priority items are allocated space first. `Spacer` elements fill remaining space after fixed-size children are resolved.

## SwiftUI Compatibility

`OpenLayoutDSL` includes a SwiftUI compatibility layer for testing. Types conforming to `SwiftUIViewProvider` can produce equivalent SwiftUI views, allowing layout behavior to be validated against SwiftUI's own engine via snapshot tests.

## License

MIT
