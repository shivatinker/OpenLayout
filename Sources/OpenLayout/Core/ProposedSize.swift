//
//  ProposedSize.swift
//
//
//  Created by Andrii Zinoviev on 15.06.2024.
//

import CoreGraphics

struct ProposedSize {
    var width: CGFloat?
    var height: CGFloat?
    
    static let zero = ProposedSize(width: 0, height: 0)
    static let unspecified = ProposedSize(width: nil, height: nil)
    static let infinity = ProposedSize(width: .infinity, height: .infinity)
    
    func replacingUnspecifiedDimensions(by size: CGSize) -> CGSize {
        CGSize(
            width: self.width ?? size.width,
            height: self.height ?? size.height
        )
    }
    
    init(width: CGFloat?, height: CGFloat?) {
        self.width = width
        self.height = height
    }
    
    init(size: CGSize) {
        self.width = size.width
        self.height = size.height
    }
}
