//
//  CGRectExtensions.swift
//
//
//  Created by Andrii Zinoviev on 12.06.2024.
//

import CoreGraphics

extension CGRect {
    init(anchorPoint: CGPoint, anchor: Alignment, size: CGSize) {
        self.init(
            center: anchor.center(anchorPoint: anchorPoint, in: size),
            size: size
        )
    }
    
    init(center: CGPoint, size: CGSize) {
        self.init(
            origin: CGPoint(
                x: center.x - size.width / 2,
                y: center.y - size.height / 2
            ),
            size: size
        )
    }
    
    var center: CGPoint {
        CGPoint(
            x: self.midX,
            y: self.midY
        )
    }
}
