//
//  Node.swift
//
//
//  Created by Andrii Zinoviev on 12.06.2024.
//

import CoreGraphics

class Node: LayoutElement {
    private let layout: Layout
    private let children: [Node]
    var info = NodeInfo()
    
    private(set) var frame: CGRect?
    
    init(layout: Layout, children: [Node]) {
        self.layout = layout
        self.children = children
    }
    
    final func place(at point: CGPoint, anchor: Alignment, proposal: ProposedSize) {
        let size = self.sizeThatFits(proposal)
        
        let selfFrame = CGRect(anchorPoint: point, anchor: anchor, size: size)
        
        self.frame = selfFrame
        
        for child in self.children {
            child.frame = nil
        }
        
        self.layout.placeChildren(self.children, in: selfFrame)
        
        for child in self.children {
            guard let frame = child.frame else {
                preconditionFailure("Every child must have non-nil frame after layout")
            }
            
            guard frame.isValidLayoutRectangle else {
                Configuration.current.warningHandler.handle(.invalidFrame(frame: frame))
                continue
            }
            
            guard selfFrame.fullyContains(frame) else {
                Configuration.current.warningHandler.handle(.overflow(parentFrame: selfFrame, childFrame: frame))
                continue
            }
        }
    }

    final func sizeThatFits(_ proposal: ProposedSize) -> CGSize {
        self.layout.sizeThatFits(proposal, children: self.children)
    }
    
    final func accept(_ visitor: inout some NodeVisitor) {
        visitor.visit(self)
        
        for child in self.children {
            child.accept(&visitor)
        }
    }
}

extension CGRect {
    var isValidLayoutRectangle: Bool {
        self.origin.x.isFinite && self.origin.y.isFinite && self.width.isFinite && self.height.isFinite
    }
    
    func fullyContains(_ rect: CGRect) -> Bool {
        self.minX <= rect.minX && self.maxX >= rect.maxX && self.minY <= rect.minY && self.maxY >= rect.maxY
    }
}
