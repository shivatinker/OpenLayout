//
//  TextLayout.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 11.07.2025.
//

import OpenLayout

public struct TextLayout: LeafLayout {
    private let engine = CoreTextLayoutEngine()
    
    public let text: String
    
    public init(text: String) {
        self.text = text
    }
    
    public func sizeThatFits(_ proposal: ProposedSize) -> CGSize {
        let proposal = proposal.ceil()
        
        let attributes = TextAttributes.current
        
        let result = self.engine.sizeThatFits(
            proposal,
            text: self.text,
            attributes: attributes
        )
        
        return result
    }
}
