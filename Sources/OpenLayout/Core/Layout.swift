//
//  Layout.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 26.05.2026.
//

import CoreFoundation

// MARK: Types

public struct ProposedSize: Sendable, Hashable {
    public let width: CGFloat?
    public let height: CGFloat?

    public init(width: CGFloat?, height: CGFloat?) {
        self.width = width
        self.height = height
    }

    public init(_ size: CGSize) {
        self.width = size.width
        self.height = size.height
    }

    public func replacingUnspecifiedDimensions(by size: CGSize) -> CGSize {
        CGSize(width: self.width ?? size.width, height: self.height ?? size.height)
    }

    public static let unspecified = Self(width: nil, height: nil)
    public static let zero = Self(width: 0, height: 0)
    public static let infinity = Self(width: .infinity, height: .infinity)
}

public protocol ChildMeasurement {
    func sizeThatFits(proposal: ProposedSize) -> CGSize
    func layoutPriority() -> Int
}

public protocol ChildPlacement: ChildMeasurement {
    func place(frame: CGRect)
}

// MARK: Layout

public protocol Layout {
    func sizeThatFits(_ children: [ChildMeasurement], proposal: ProposedSize) -> CGSize
    func placeChildren(_ children: [ChildPlacement], bounds: CGRect)
    
    func layoutDirection() -> Axis?
    func layoutPriority() -> Int
}

extension Layout {
    public func layoutDirection() -> Axis? {
        nil
    }
    
    public func layoutPriority() -> Int {
        0
    }
}

// MARK: UnaryLayout

public protocol UnaryLayout {
    func sizeThatFits(_ child: some ChildMeasurement, proposal: ProposedSize) -> CGSize
    func placeChild(_ child: some ChildPlacement, bounds: CGRect)
}

struct UnaryLayoutAdapter<L: UnaryLayout>: Layout {
    let layout: L
    
    func sizeThatFits(_ children: [any ChildMeasurement], proposal: ProposedSize) -> CGSize {
        precondition(children.count == 1)
        return self.layout.sizeThatFits(children[0], proposal: proposal)
    }
    
    func placeChildren(_ children: [any ChildPlacement], bounds: CGRect) {
        precondition(children.count == 1)
        self.layout.placeChild(children[0], bounds: bounds)
    }
}

// MARK: LeafLayout

public protocol LeafLayout {
    func sizeThatFits(proposal: ProposedSize) -> CGSize
    func layoutPriority() -> Int
}

extension LeafLayout {
    public func layoutPriority() -> Int {
        0
    }
}

struct LeafLayoutAdapter<L: LeafLayout>: Layout {
    let layout: L
    
    func sizeThatFits(_ children: [any ChildMeasurement], proposal: ProposedSize) -> CGSize {
        precondition(children.isEmpty)
        return self.layout.sizeThatFits(proposal: proposal)
    }
    
    func placeChildren(_ children: [any ChildPlacement], bounds: CGRect) {
        precondition(children.isEmpty)
    }
    
    func layoutPriority() -> Int {
        self.layout.layoutPriority()
    }
}
