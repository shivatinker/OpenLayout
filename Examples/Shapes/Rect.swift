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
    static let fillCGColor = CGColor(colorSpace: sRGB, components: [0, 0, 1, 1])!
    static let strokeCGColor = CGColor(colorSpace: sRGB, components: [0, 0, 0, 1])!

    func makeSwiftUIView() -> some View {
        Rectangle()
            .fill(Color(cgColor: Self.fillCGColor))
            .border(Color(cgColor: Self.strokeCGColor), width: 1)
    }
}
