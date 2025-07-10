//
//  CGRect+OpenLayout.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 10.07.2025.
//

import CoreGraphics

extension CGRect {
    init(center: CGPoint, size: CGSize) {
        self.init(
            origin: CGPoint(
                x: center.x - size.width / 2,
                y: center.y - size.height / 2
            ),
            size: size
        )
    }
    
    init(anchorPoint: AnchorPoint, size: CGSize) {
        self.init(
            center: anchorPoint.alignment.center(anchorPoint: anchorPoint.point, in: size),
            size: size
        )
    }
    
    func anchorPoint(for alignment: Alignment) -> AnchorPoint {
        AnchorPoint(
            point: alignment.anchorPoint(in: self),
            alignment: alignment
        )
    }
    
    var center: CGPoint {
        CGPoint(
            x: self.midX,
            y: self.midY
        )
    }
    
    func inset(edges: Edge.Set, _ inset: CGFloat) -> CGRect {
        let size = self.size.inset(edges: edges, inset)
        
        let origin = CGPoint(
            x: self.origin.x + (edges.contains(.left) ? inset : 0),
            y: self.origin.y + (edges.contains(.top) ? inset : 0)
        )
        
        return CGRect(origin: origin, size: size)
    }
}
