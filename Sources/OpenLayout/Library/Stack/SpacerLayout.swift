//
//  SpacerLayout.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 21.05.2026.
//

import CoreFoundation

public struct SpacerLayout: LeafLayout {
    public let minLength: CGFloat
    public let layoutDirection: Axis?
    
    public init(minLength: CGFloat, layoutDirection: Axis?) {
        self.minLength = minLength
        self.layoutDirection = layoutDirection
    }
    
    public func sizeThatFits(proposal: ProposedSize) -> CGSize {
        guard let layoutDirection else {
            return proposal.replacingUnspecifiedDimensions(
                by: CGSize(width: self.minLength, height: self.minLength)
            )
        }
        
        switch layoutDirection {
        case .horizontal:
            return CGSize(
                width: self.calculateLength(proposal: proposal.width),
                height: 0
            )
            
        case .vertical:
            return CGSize(
                width: 0,
                height: self.calculateLength(proposal: proposal.height)
            )
        }
    }
    
    private func calculateLength(proposal: CGFloat?) -> CGFloat {
        guard let proposal else {
            return self.minLength
        }
        
        return max(proposal, self.minLength)
    }
    
    public func layoutPriority() -> Int {
        -1
    }
}
