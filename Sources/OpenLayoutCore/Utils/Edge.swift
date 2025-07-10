import CoreGraphics

public enum Axis {
    case horizontal
    case vertical
    
    var crossAxis: Axis {
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
