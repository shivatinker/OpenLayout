//
//  Alignment.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 19.05.2026.
//

import CoreGraphics

public struct Alignment: Sendable {
    public enum Vertical: Sendable {
        case top
        case center
        case bottom

        var stackAlignment: StackAlignment {
            switch self {
            case .top: .min
            case .center: .center
            case .bottom: .max
            }
        }
    }

    public enum Horizontal: Sendable {
        case left
        case center
        case right

        var stackAlignment: StackAlignment {
            switch self {
            case .left: .min
            case .center: .center
            case .right: .max
            }
        }
    }

    public let vertical: Vertical
    public let horizontal: Horizontal

    public init(vertical: Vertical, horizontal: Horizontal) {
        self.vertical = vertical
        self.horizontal = horizontal
    }

    public static let topLeft = Alignment(vertical: .top, horizontal: .left)
    public static let top = Alignment(vertical: .top, horizontal: .center)
    public static let topRight = Alignment(vertical: .top, horizontal: .right)

    public static let left = Alignment(vertical: .center, horizontal: .left)
    public static let center = Alignment(vertical: .center, horizontal: .center)
    public static let right = Alignment(vertical: .center, horizontal: .right)

    public static let bottomLeft = Alignment(vertical: .bottom, horizontal: .left)
    public static let bottom = Alignment(vertical: .bottom, horizontal: .center)
    public static let bottomRight = Alignment(vertical: .bottom, horizontal: .right)

    public var anchorPoint: AnchorPoint {
        switch (self.vertical, self.horizontal) {
        case (.top, .left): return .topLeft
        case (.top, .center): return .topCenter
        case (.top, .right): return .topRight
        case (.center, .left): return .centerLeft
        case (.center, .center): return .center
        case (.center, .right): return .centerRight
        case (.bottom, .left): return .bottomLeft
        case (.bottom, .center): return .bottomCenter
        case (.bottom, .right): return .bottomRight
        }
    }
}
