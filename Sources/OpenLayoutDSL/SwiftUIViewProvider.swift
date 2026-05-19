//
//  SwiftUIViewProvider.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 19.05.2026.
//

import OpenLayout
import SwiftUI

@MainActor
public protocol SwiftUIViewProvider {
    associatedtype SwiftUIContent: View
    
    func makeSwiftUIView() -> SwiftUIContent
}

public enum SwiftUISupport {
    @MainActor
    public static func swiftUIView(for item: some LayoutItem) -> AnyView {
        guard let provider = item as? any SwiftUIViewProvider else {
            preconditionFailure("\(item) is not supported for SwiftUI testing.")
        }
        
        return AnyView(provider.makeSwiftUIView())
    }
}

public protocol SwiftUICompatibleLayout {
    associatedtype SwiftUIContent: View
    
    func makeSwiftUIView(children: [AnyView]) -> SwiftUIContent
}

public protocol SwiftUICompatibleUnaryLayout {
    associatedtype SwiftUIContent: View
    
    func makeSwiftUIView(child: AnyView) -> SwiftUIContent
}

extension UnaryContainerItem: SwiftUIViewProvider {
    func makeSwiftUIView() -> some View {
        guard let layout = self.layout as? any SwiftUICompatibleUnaryLayout else {
            preconditionFailure("\(self.layout) is not supported for SwiftUI testing.")
        }
        
        let child = SwiftUISupport.swiftUIView(for: self.child)
            
        return AnyView(layout.makeSwiftUIView(child: child))
    }
}

extension ContainerItem: SwiftUIViewProvider {
    func makeSwiftUIView() -> some View {
        guard let layout = self.layout as? any SwiftUICompatibleLayout else {
            preconditionFailure("\(self.layout) is not supported for SwiftUI testing.")
        }
        
        let children = self.children.map {
            SwiftUISupport.swiftUIView(for: $0)
        }
            
        return AnyView(layout.makeSwiftUIView(children: children))
    }
}

extension PaddingLayout: SwiftUICompatibleUnaryLayout {
    public func makeSwiftUIView(child: AnyView) -> some View {
        child.padding(self.edges.swiftUIValue, self.padding)
    }
}

extension FixedFrameLayout: SwiftUICompatibleUnaryLayout {
    public func makeSwiftUIView(child: AnyView) -> some View {
        child.frame(width: self.width, height: self.height, alignment: self.alignment.swiftUIValue)
    }
}

extension FlexibleFrameLayout: SwiftUICompatibleUnaryLayout {
    public func makeSwiftUIView(child: AnyView) -> some View {
        child.frame(
            minWidth: self.minWidth,
            maxWidth: self.maxWidth,
            minHeight: self.minHeight,
            maxHeight: self.maxHeight,
            alignment: self.alignment.swiftUIValue
        )
    }
}

extension FixedSizeLayout: SwiftUICompatibleUnaryLayout {
    public func makeSwiftUIView(child: AnyView) -> some View {
        child.fixedSize(horizontal: self.horizontal, vertical: self.vertical)
    }
}

extension BackgroundLayout: SwiftUICompatibleLayout {
    // children[0] = background, children[1] = content (matches Background.swift DSL ordering)
    public func makeSwiftUIView(children: [AnyView]) -> some View {
        children[1].background(children[0])
    }
}

extension OpenLayout.HStackLayout: SwiftUICompatibleLayout {
    public func makeSwiftUIView(children: [AnyView]) -> some View {
        SwiftUI.HStack(alignment: self.alignment.swiftUIValue, spacing: self.spacing) {
            ForEach(children.indices, id: \.self) { children[$0] }
        }
    }
}

extension OpenLayout.VStackLayout: SwiftUICompatibleLayout {
    public func makeSwiftUIView(children: [AnyView]) -> some View {
        SwiftUI.VStack(alignment: self.alignment.swiftUIValue, spacing: self.spacing) {
            ForEach(children.indices, id: \.self) { children[$0] }
        }
    }
}

// MARK: - Alignment mappings

extension OpenLayout.Alignment {
    var swiftUIValue: SwiftUI.Alignment {
        switch (self.vertical, self.horizontal) {
        case (.top, .left): .topLeading
        case (.top, .center): .top
        case (.top, .right): .topTrailing
        case (.center, .left): .leading
        case (.center, .center): .center
        case (.center, .right): .trailing
        case (.bottom, .left): .bottomLeading
        case (.bottom, .center): .bottom
        case (.bottom, .right): .bottomTrailing
        }
    }
}

extension OpenLayout.Alignment.Vertical {
    var swiftUIValue: SwiftUI.VerticalAlignment {
        switch self {
        case .top: .top
        case .center: .center
        case .bottom: .bottom
        }
    }
}

extension OpenLayout.Alignment.Horizontal {
    var swiftUIValue: SwiftUI.HorizontalAlignment {
        switch self {
        case .left: .leading
        case .center: .center
        case .right: .trailing
        }
    }
}

extension OpenLayout.Edge.Set {
    var swiftUIValue: SwiftUI.Edge.Set {
        var result = SwiftUI.Edge.Set()

        for edge in OpenLayout.Edge.allCases {
            if self.contains(edge) {
                result.insert(edge.swiftUIValue)
            }
        }

        return result
    }
}

extension OpenLayout.Edge {
    var swiftUIValue: SwiftUI.Edge.Set {
        switch self {
        case .top: .top
        case .left: .leading
        case .right: .trailing
        case .bottom: .bottom
        }
    }
}
