//
//  ProposedSize.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 09.07.2025.
//

import CoreGraphics

public struct ProposedSize: Sendable, CustomStringConvertible, Hashable {
    public var width: CGFloat?
    public var height: CGFloat?
    
    public static let zero = ProposedSize(width: 0, height: 0)
    public static let unspecified = ProposedSize(width: nil, height: nil)
    public static let infinity = ProposedSize(width: .infinity, height: .infinity)
    
    public func replacingUnspecifiedDimensions(by size: CGSize) -> CGSize {
        CGSize(
            width: self.width ?? size.width,
            height: self.height ?? size.height
        )
    }
    
    public init(width: CGFloat?, height: CGFloat?) {
        self.width = width
        self.height = height
    }
    
    public init(_ size: CGSize) {
        self.width = size.width
        self.height = size.height
    }
    
    public var description: String {
        "\(self.description(for: self.width)) x \(self.description(for: self.height))"
    }
    
    private func description(for dimension: CGFloat?) -> String {
        guard let dimension else {
            return "nil"
        }
        
        return dimension.description
    }
}
