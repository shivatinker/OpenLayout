//
//  Alignment.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 09.07.2025.
//

import CoreGraphics

public struct AnchorPoint {
    let point: CGPoint
    let alignment: Alignment
}

public struct Alignment: Sendable {
    public enum Vertical: Sendable {
        case top
        case center
        case bottom
        
        func swapped() -> Horizontal {
            switch self {
            case .top:
                .left
            case .center:
                .center
            case .bottom:
                .right
            }
        }
    }
    
    public enum Horizontal: Sendable {
        case left
        case center
        case right
        
        func swapped() -> Vertical {
            switch self {
            case .left:
                .top
            case .center:
                .center
            case .right:
                .bottom
            }
        }
    }
    
    let vertical: Vertical
    let horizontal: Horizontal
    
    public static let topLeft = Alignment(vertical: .top, horizontal: .left)
    public static let top = Alignment(vertical: .top, horizontal: .center)
    public static let topRight = Alignment(vertical: .top, horizontal: .right)
    
    public static let left = Alignment(vertical: .center, horizontal: .left)
    public static let center = Alignment(vertical: .center, horizontal: .center)
    public static let right = Alignment(vertical: .center, horizontal: .right)
    
    public static let bottomLeft = Alignment(vertical: .bottom, horizontal: .left)
    public static let bottom = Alignment(vertical: .bottom, horizontal: .center)
    public static let bottomRight = Alignment(vertical: .bottom, horizontal: .right)
    
    func anchorPoint(in rect: CGRect) -> CGPoint {
        let x = switch self.horizontal {
        case .left:
            rect.center.x - rect.width / 2
        case .center:
            rect.center.x
        case .right:
            rect.center.x + rect.width / 2
        }
        
        let y = switch self.vertical {
        case .top:
            rect.center.y - rect.height / 2
        case .center:
            rect.center.y
        case .bottom:
            rect.center.y + rect.height / 2
        }
        
        return CGPoint(x: x, y: y)
    }
    
    func center(anchorPoint: CGPoint, in size: CGSize) -> CGPoint {
        let x = switch self.horizontal {
        case .left:
            anchorPoint.x + size.width / 2
        case .center:
            anchorPoint.x
        case .right:
            anchorPoint.x - size.width / 2
        }
        
        let y = switch self.vertical {
        case .top:
            anchorPoint.y + size.height / 2
        case .center:
            anchorPoint.y
        case .bottom:
            anchorPoint.y - size.height / 2
        }
        
        return CGPoint(x: x, y: y)
    }
    
    func swapped() -> Alignment {
        Alignment(
            vertical: self.horizontal.swapped(),
            horizontal: self.vertical.swapped()
        )
    }
}
