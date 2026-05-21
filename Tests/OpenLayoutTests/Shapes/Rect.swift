//
//  Rect.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 17.05.2026.
//

import CoreFoundation
import CoreGraphics
import OpenLayout
import OpenLayoutDSL
import SwiftUI

struct RectLayout: LeafLayout {
    func sizeThatFits(proposal: ProposedSize) -> CGSize {
        proposal.replacingUnspecifiedDimensions(by: CGSize(width: 10.0, height: 10.0))
    }
}

struct FakeTextLayout: LeafLayout {
    let size: CGFloat
    
    func sizeThatFits(proposal: ProposedSize) -> CGSize {
        let width = proposal.width ?? (self.size / 10)
        
        if width.isInfinite {
            return CGSize(width: self.size / 10, height: 10)
        }
        
        return CGSize(width: width, height: self.height(for: max(width, 1)))
    }

    private func height(for width: CGFloat) -> CGFloat {
        max(self.size / width, 10)
    }
}

private struct FakeTextSwiftUILayout: SwiftUI.Layout {
    let size: CGFloat

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = proposal.width ?? (self.size / 10)
        if width.isInfinite {
            return CGSize(width: self.size / 10, height: 10)
        }
        return CGSize(width: width, height: max(self.size / max(width, 1), 10))
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {}
}

struct FakeText: LayoutItem {
    let id: Int
    let size: CGFloat
    
    func makeLayoutNode(context: LayoutContext) -> LayoutNode {
        LayoutNode.makeLeafNode(
            context: context,
            layout: FakeTextLayout(size: self.size),
            data: self.id
        )
    }
}

extension FakeText: SwiftUIViewProvider {
    func makeSwiftUIView() -> some View {
        FakeTextSwiftUILayout(size: self.size) {
            // SwiftUI is buggy with layouts with no children.
            Rectangle().opacity(0.0)
        }
        .background(Rect(self.id).makeSwiftUIView())
    }
}

struct Rect: LayoutItem {
    let id: Int
    
    init(_ id: Int) {
        self.id = id
    }
    
    func makeLayoutNode(context: LayoutContext) -> LayoutNode {
        LayoutNode.makeLeafNode(
            context: context,
            layout: RectLayout(),
            data: self.id
        )
    }
}

extension Rect: SwiftUIViewProvider {
    private static let sRGB = CGColorSpace(name: CGColorSpace.sRGB)!

    static let strokeCGColor = CGColor(colorSpace: sRGB, components: [0, 0, 0, 1])!

    private static let fillCGColors: [CGColor] = [
        CGColor(colorSpace: sRGB, components: [0.20, 0.60, 1.00, 1])!,
        CGColor(colorSpace: sRGB, components: [0.20, 0.80, 0.40, 1])!,
        CGColor(colorSpace: sRGB, components: [1.00, 0.80, 0.20, 1])!,
        CGColor(colorSpace: sRGB, components: [1.00, 0.40, 0.20, 1])!,
        CGColor(colorSpace: sRGB, components: [0.80, 0.20, 0.80, 1])!,
        CGColor(colorSpace: sRGB, components: [0.20, 0.80, 0.80, 1])!,
        CGColor(colorSpace: sRGB, components: [1.00, 0.60, 0.80, 1])!,
        CGColor(colorSpace: sRGB, components: [0.60, 0.40, 1.00, 1])!,
        CGColor(colorSpace: sRGB, components: [0.40, 1.00, 0.60, 1])!,
        CGColor(colorSpace: sRGB, components: [1.00, 1.00, 0.40, 1])!,
    ]

    static func fillCGColor(for id: Int) -> CGColor {
        self.fillCGColors[id % self.fillCGColors.count]
    }

    func makeSwiftUIView() -> some View {
        Rectangle()
            .fill(Color(cgColor: Self.fillCGColor(for: self.id)))
            .border(Color(cgColor: Self.strokeCGColor), width: 1)
    }
}
