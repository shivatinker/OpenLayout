//
//  AnchorPoint.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 14.05.2026.
//

import CoreGraphics

public enum AnchorPoint {
    case topLeft
    case topCenter
    case topRight
    case centerLeft
    case center
    case centerRight
    case bottomLeft
    case bottomCenter
    case bottomRight
}

extension CGRect {
    public func anchorPoint(_ anchor: AnchorPoint) -> CGPoint {
        switch anchor {
        case .topLeft: return CGPoint(x: minX, y: minY)
        case .topCenter: return CGPoint(x: midX, y: minY)
        case .topRight: return CGPoint(x: maxX, y: minY)
        case .centerLeft: return CGPoint(x: minX, y: midY)
        case .center: return CGPoint(x: midX, y: midY)
        case .centerRight: return CGPoint(x: maxX, y: midY)
        case .bottomLeft: return CGPoint(x: minX, y: maxY)
        case .bottomCenter: return CGPoint(x: midX, y: maxY)
        case .bottomRight: return CGPoint(x: maxX, y: maxY)
        }
    }
    
    public init(point: CGPoint, anchor: AnchorPoint, size: CGSize) {
        let xFraction: CGFloat
        let yFraction: CGFloat
        
        switch anchor {
        case .topLeft:
            xFraction = 0
            yFraction = 0

        case .topCenter:
            xFraction = 0.5
            yFraction = 0

        case .topRight:
            xFraction = 1
            yFraction = 0

        case .centerLeft:
            xFraction = 0
            yFraction = 0.5

        case .center:
            xFraction = 0.5
            yFraction = 0.5

        case .centerRight:
            xFraction = 1
            yFraction = 0.5

        case .bottomLeft:
            xFraction = 0
            yFraction = 1

        case .bottomCenter:
            xFraction = 0.5
            yFraction = 1

        case .bottomRight:
            xFraction = 1
            yFraction = 1
        }
        
        self.init(
            x: point.x - xFraction * size.width,
            y: point.y - yFraction * size.height,
            width: size.width,
            height: size.height
        )
    }
}

extension ChildPlacement {
    public func place(at point: CGPoint, anchor: AnchorPoint, proposal: ProposedSize) {
        let size = self.sizeThatFits(proposal: proposal)
        self.place(at: point, anchor: anchor, size: size)
    }

    public func place(at point: CGPoint, anchor: AnchorPoint, size: CGSize) {
        self.place(frame: CGRect(point: point, anchor: anchor, size: size))
    }
}
