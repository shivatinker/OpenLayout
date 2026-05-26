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
    
    private let layout: any Layout
    public let children: [LayoutNode]
    public let leafData: Any?
    
    public private(set) var frame: CGRect?
    private var sizeThatFitsCache: [ProposedSize: CGSize] = [:]
    
    private init(
        context: LayoutContext,
        layout: any Layout,
        children: [LayoutNode],
        leafData: Any? = nil
    ) {
        self.id = context.makeNodeID()
        self.layout = layout
        self.issueRecorder = context.issueRecorder
        self.leafData = leafData
        self.children = children
    }

    public static func makeLeafNode(
        context: LayoutContext,
        layout: some LeafLayout,
        data: Any?
    ) -> LayoutNode {
        LayoutNode(context: context, layout: LeafLayoutAdapter(layout: layout), children: [], leafData: data)
    }

    public static func makeContainerNode(
        context: LayoutContext,
        layout: Layout,
        children: [LayoutNode]
    ) -> LayoutNode {
        LayoutNode(context: context, layout: layout, children: children)
    }

    public static func makeUnaryNode(
        context: LayoutContext,
        layout: some UnaryLayout,
        child: LayoutNode
    ) -> LayoutNode {
        LayoutNode(context: context, layout: UnaryLayoutAdapter(layout: layout), children: [child])
    }

    public func doLayout() {
        guard let frame else {
            self.issueRecorder.recordError("layout: Frame is not set for node \(self)")
            return
        }

        self.layout.placeChildren(self.children, bounds: frame)

        for child in self.children {
            if child.frame == nil {
                self.issueRecorder.recordError("layout: Frame is not placed for child node \(child) of node \(self)")
            }
            
            child.doLayout()
        }
    }
    
    public func layoutPriority() -> Int {
        self.layout.layoutPriority()
    }
    
    public var description: String {
        "<LayoutNode id=\(self.id); \(self.children.count) children; layout=\(self.layout)>"
    }
    
    // MARK: ChildMeasurement

    public func sizeThatFits(proposal: ProposedSize) -> CGSize {
        if let cachedSize = self.sizeThatFitsCache[proposal] {
            return cachedSize
        }
        
        let size = self.layout.sizeThatFits(self.children, proposal: proposal)
        self.sizeThatFitsCache[proposal] = size
        return size
    }
    
    // MARK: ChildPlacement

    public func place(frame: CGRect) {
        guard self.frame == nil else {
            self.issueRecorder.recordError("place: Frame already set for node \(self)")
            return
        }

        self.frame = frame
    }
}
