//
//  Rune.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 23.05.2026.
//

import CoreFoundation
import OpenLayout
import OpenLayoutDSL

public final class Rune {
    private let width: Int
    private let height: Int
    
    public init(width: Int, height: Int) {
        self.width = width
        self.height = height
    }
    
    public func draw(_ root: LayoutItem) {
        let layoutContext = LayoutContext()
        let node = root.makeLayoutNode(context: layoutContext)
        
        let fittedSize = node.sizeThatFits(
            proposal: ProposedSize(
                width: CGFloat(self.width),
                height: CGFloat(self.height)
            )
        )
        
        let bounds = CGRect(origin: .zero, size: fittedSize)
        node.place(frame: CGRect(point: bounds.center, anchor: .center, size: fittedSize))
        node.doLayout()
        
//        print(LayoutNodeDumper().dump(node))
        
        let context = RuneContext(width: self.width, height: self.height)
        self.drawNode(node, context: context)
        
        context.draw()
    }
    
    private func drawNode(_ node: LayoutNode, context: some DrawContext) {
        if let leafData = node.leafData {
            guard let drawable = leafData as? Drawable else {
                preconditionFailure("Unexpected leaf data: \(leafData)")
            }
            
            guard let frame = node.frame else {
                preconditionFailure("Not layout node: \(node)")
            }
            
            let integerFrame = Rect(
                x: Int(frame.origin.x),
                y: Int(frame.origin.y),
                width: Int(frame.width),
                height: Int(frame.height)
            )
            
            drawable.draw(context: context, frame: integerFrame)
        }
        
        for child in node.children {
            self.drawNode(child, context: context)
        }
    }
}

private final class RuneContext: DrawContext {
    private let width: Int
    private let height: Int
    
    private var buffer: [[Character]]
    
    init(width: Int, height: Int) {
        self.width = width
        self.height = height
        
        self.buffer = Array(repeating: Array(repeating: " ", count: width), count: height)
    }
    
    func setCharacter(x: Int, y: Int, _ character: Character, attributes: CharacterAttributes) {
        guard x >= 0, x < self.width, y >= 0, y < self.height else {
            return
        }
        
        self.buffer[y][x] = character
    }
    
    func draw() {
        for line in self.buffer {
            for character in line {
                print(character, terminator: "")
            }
            
            print("", terminator: "\n")
        }
    }
}
