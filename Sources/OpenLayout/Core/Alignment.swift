//
//  Alignment.swift
//
//
//  Created by Andrii Zinoviev on 12.06.2024.
//

import CoreGraphics

struct Alignment {
    enum Vertical {
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
    
    enum Horizontal {
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
    
    static let topLeft = Alignment(vertical: .top, horizontal: .left)
    static let top = Alignment(vertical: .top, horizontal: .center)
    static let topRight = Alignment(vertical: .top, horizontal: .right)
    
    static let left = Alignment(vertical: .center, horizontal: .left)
    static let center = Alignment(vertical: .center, horizontal: .center)
    static let right = Alignment(vertical: .center, horizontal: .right)
    
    static let bottomLeft = Alignment(vertical: .bottom, horizontal: .left)
    static let bottom = Alignment(vertical: .bottom, horizontal: .center)
    static let bottomRight = Alignment(vertical: .bottom, horizontal: .right)
    
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
