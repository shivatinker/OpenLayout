//
//  LayoutNode.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 14.05.2026.
//

import CoreFoundation

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

public protocol ContainerLayout {
    func sizeThatFits(_ children: [ChildMeasurement], proposal: ProposedSize) -> CGSize
    func placeChildren(_ children: [ChildPlacement], bounds: CGRect)
    
    func layoutDirection() -> Axis?
}

extension ContainerLayout {
    public func layoutDirection() -> Axis? {
        nil
    }
}

public protocol UnaryLayout {
    func sizeThatFits(_ child: some ChildMeasurement, proposal: ProposedSize) -> CGSize
    func placeChild(_ child: some ChildPlacement, bounds: CGRect)
}

public protocol LeafLayout {
    func sizeThatFits(proposal: ProposedSize) -> CGSize
    func layoutPriority() -> Int
}

extension LeafLayout {
    public func layoutPriority() -> Int {
        0
    }
}

public struct LayoutIssue: CustomStringConvertible {
    public let message: String

    public var description: String {
        self.message
    }
}

public struct NodeID: Hashable, CustomStringConvertible {
    let rawValue: Int
    
    public var description: String {
        "#\(self.rawValue)"
    }
}

public final class LayoutIssueRecorder {
    public private(set) var issues: [LayoutIssue] = []

    public func recordError(_ message: String) {
        self.issues.append(LayoutIssue(message: message))
    }
}

public struct LayoutContext {
    private final class IDGenerator {
        var next = 0
    }

    private let generator = IDGenerator()
    public let issueRecorder: LayoutIssueRecorder
    public var layoutDirection: Axis?

    public init() {
        self.issueRecorder = LayoutIssueRecorder()
    }

    func makeNodeID() -> NodeID {
        defer { self.generator.next += 1 }
        return NodeID(rawValue: self.generator.next)
    }
}

public final class LayoutNode: ChildPlacement, CustomStringConvertible {
    public let id: NodeID
    private let issueRecorder: LayoutIssueRecorder

    public private(set) var frame: CGRect?
    private let layout: LayoutStorage
    private var sizeThatFitsCache: [ProposedSize: CGSize] = [:]
    
    public var children: [LayoutNode] {
        self.layout.children
    }

    private init(context: LayoutContext, layout: LayoutStorage) {
        self.id = context.makeNodeID()
        self.issueRecorder = context.issueRecorder
        self.layout = layout
    }

    public static func makeLeafNode(
        context: LayoutContext,
        layout: LeafLayout,
        data: Any?
    ) -> LayoutNode {
        LayoutNode(context: context, layout: LeafLayoutStorage(layout: layout, data: data))
    }

    public static func makeContainerNode(
        context: LayoutContext,
        layout: ContainerLayout,
        children: [LayoutNode]
    ) -> LayoutNode {
        LayoutNode(context: context, layout: ContainerLayoutStorage(children: children, layout: layout))
    }

    public static func makeUnaryNode(
        context: LayoutContext,
        layout: UnaryLayout,
        child: LayoutNode
    ) -> LayoutNode {
        LayoutNode(context: context, layout: UnaryLayoutStorage(child: child, layout: layout))
    }

    public func doLayout() {
        guard let frame else {
            self.issueRecorder.recordError("layout: Frame is not set for node \(self)")
            return
        }

        self.layout.placeChildren(bounds: frame)

        for child in self.layout.children {
            if child.frame == nil {
                self.issueRecorder.recordError("layout: Frame is not placed for child node \(child) of node \(self)")
            }
            
            child.doLayout()
        }
    }

    public func sizeThatFits(proposal: ProposedSize) -> CGSize {
        if let cachedSize = self.sizeThatFitsCache[proposal] {
            return cachedSize
        }
        
        let size = self.layout.sizeThatFits(proposal: proposal)
        self.sizeThatFitsCache[proposal] = size
        return size
    }

    public func place(frame: CGRect) {
        guard self.frame == nil else {
            self.issueRecorder.recordError("place: Frame already set for node \(self)")
            return
        }

        self.frame = frame
    }
    
    public var leafData: Any? {
        guard let leafLayout = self.layout as? LeafLayoutStorage else {
            return nil
        }
        
        return leafLayout.data
    }
    
    public func layoutPriority() -> Int {
        self.layout.layoutPriority()
    }
    
    public var description: String {
        "<LayoutNode id=\(self.id); \(self.layout.children.count) children; layout=\(self.layout)>"
    }
}

private protocol LayoutStorage {
    var children: [LayoutNode] { get }

    func sizeThatFits(proposal: ProposedSize) -> CGSize
    func layoutPriority() -> Int
    func placeChildren(bounds: CGRect)
}

extension LayoutStorage {
    func layoutPriority() -> Int {
        0
    }
}

private struct ContainerLayoutStorage: LayoutStorage, CustomStringConvertible {
    private let layout: ContainerLayout

    let children: [LayoutNode]

    init(children: [LayoutNode], layout: ContainerLayout) {
        self.children = children
        self.layout = layout
    }

    func sizeThatFits(proposal: ProposedSize) -> CGSize {
        self.layout.sizeThatFits(self.children, proposal: proposal)
    }

    func placeChildren(bounds: CGRect) {
        self.layout.placeChildren(self.children, bounds: bounds)
    }
    
    var description: String {
        "\(type(of: self.layout))"
    }
}

private struct UnaryLayoutStorage: LayoutStorage, CustomStringConvertible {
    private let child: LayoutNode
    private let layout: UnaryLayout

    var children: [LayoutNode] { [self.child] }

    init(child: LayoutNode, layout: UnaryLayout) {
        self.child = child
        self.layout = layout
    }

    func sizeThatFits(proposal: ProposedSize) -> CGSize {
        self.layout.sizeThatFits(self.child, proposal: proposal)
    }

    func placeChildren(bounds: CGRect) {
        self.layout.placeChild(self.child, bounds: bounds)
    }
    
    var description: String {
        "\(type(of: self.layout))"
    }
}

private struct LeafLayoutStorage: LayoutStorage, CustomStringConvertible {
    private let layout: LeafLayout
    let data: Any?

    var children: [LayoutNode] { [] }

    init(layout: LeafLayout, data: Any?) {
        self.layout = layout
        self.data = data
    }

    func sizeThatFits(proposal: ProposedSize) -> CGSize {
        self.layout.sizeThatFits(proposal: proposal)
    }
    
    func layoutPriority() -> Int {
        self.layout.layoutPriority()
    }

    func placeChildren(bounds: CGRect) {}
    
    var description: String {
        "\(type(of: self.layout))"
    }
}
