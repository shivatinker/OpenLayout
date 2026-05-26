//
//  Text.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 23.05.2026.
//

import CoreFoundation
import OpenLayout
import OpenLayoutDSL

public struct Text: LayoutItem {
    private let text: String
    
    public init(_ text: String) {
        self.text = text
    }
    
    public func makeLayoutNode(context: LayoutContext) -> LayoutNode {
        LayoutNode.makeLeafNode(
            context: context,
            layout: Layout(text: self.text),
            data: TextDrawable(text: self.text, attributes: .default)
        )
    }
    
    private struct Layout: LeafLayout {
        let text: String
        
        func sizeThatFits(proposal: ProposedSize) -> CGSize {
            let layout = TextLayoutEngine.layoutText(
                x: 0,
                y: 0,
                text: self.text,
                maxWidth: self.layoutWidth(for: proposal)
            )
            
            return CGSize(
                width: CGFloat(layout.frame.width),
                height: CGFloat(layout.frame.height)
            )
        }
        
        private func layoutWidth(for proposal: ProposedSize) -> Int? {
            guard let width = proposal.width else {
                return nil
            }
            
            if width.isInfinite {
                return nil
            }
            
            return width.floor()
        }
    }
}

extension CGFloat {
    func floor() -> Int {
        Int(_DarwinFoundation1.floor(self))
    }
}
