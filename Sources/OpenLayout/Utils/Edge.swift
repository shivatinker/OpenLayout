//
//  Edge.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 14.05.2026.
//

import CoreGraphics

public enum Axis {
    case horizontal
    case vertical
    
    public var crossAxis: Axis {
        switch self {
        case .horizontal:
            .vertical
            
        case .vertical:
            .horizontal
        }
    }
}

public enum Edge: Int8, CaseIterable {
    case top = 1
    case left = 2
    case right = 4
    case bottom = 8
    
    public var axis: Axis {
        switch self {
        case .top:
            .vertical
            
        case .left:
            .horizontal
            
        case .right:
            .horizontal
            
        case .bottom:
            .vertical
        }
    }
    
    public struct Set: OptionSet, Sendable {
        public typealias Element = Edge.Set
        
        public let rawValue: Int8
        
        public static let top = Set(.top)
        public static let left = Set(.left)
        public static let right = Set(.right)
        public static let bottom = Set(.bottom)
        public static let all: Set = [.top, .left, .right, .bottom]
        public static let horizontal: Set = [.left, .right]
        public static let vertical: Set = [.top, .bottom]
        
        public init(_ edge: Edge) {
            self.rawValue = edge.rawValue
        }
        
        public init(rawValue: Int8) {
            self.rawValue = rawValue
        }
        
        public func contains(_ edge: Edge) -> Bool {
            self.contains(Set(edge))
        }
    }
}

extension CGSize {
    public func inset(edges: Edge.Set, _ inset: CGFloat) -> CGSize {
        var result = self
        
        for edge in Edge.allCases {
            if edges.contains(edge) {
                switch edge.axis {
                case .horizontal:
                    result.width -= inset
                    
                case .vertical:
                    result.height -= inset
                }
            }
        }
        
        return CGSize(
            width: max(result.width, 0),
            height: max(result.height, 0)
        )
    }
}

extension CGRect {
    public var center: CGPoint {
        CGPoint(
            x: self.midX,
            y: self.midY
        )
    }
    
    public func inset(edges: Edge.Set, _ inset: CGFloat) -> CGRect {
        let size = self.size.inset(edges: edges, inset)
        
        let origin = CGPoint(
            x: self.origin.x + (edges.contains(.left) ? inset : 0),
            y: self.origin.y + (edges.contains(.top) ? inset : 0)
        )
        
        return CGRect(origin: origin, size: size)
    }
}
