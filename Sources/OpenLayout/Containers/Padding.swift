//
//  Padding.swift
//
//
//  Created by Andrii Zinoviev on 16.06.2024.
//

import CoreGraphics

enum Axis {
    case horizontal
    case vertical
}

enum Edge: Int8, CaseIterable {
    case top = 1
    case left = 2
    case right = 4
    case bottom = 8
    
    var axis: Axis {
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
    
    struct Set: OptionSet {
        typealias Element = Edge.Set
        
        let rawValue: Int8
        
        static let top = Set(.top)
        static let left = Set(.left)
        static let right = Set(.right)
        static let bottom = Set(.bottom)
        static let all: Set = [.top, .left, .right, .bottom]
        static let horizontal: Set = [.left, .right]
        static let vertical: Set = [.top, .bottom]
        
        init(_ edge: Edge) {
            self.rawValue = edge.rawValue
        }
        
        init(rawValue: Int8) {
            self.rawValue = rawValue
        }
        
        func contains(_ edge: Edge) -> Bool {
            self.contains(Set(edge))
        }
    }
}

extension View {
    func padding(_ padding: CGFloat) -> some View {
        self.padding(.all, padding)
    }
    
    func padding(
        _ edges: Edge.Set,
        _ padding: CGFloat
    ) -> some View {
        precondition(padding >= 0)
        
        return Padding(edges: edges, padding: padding) {
            self
        }
    }
}

private struct Padding: UnaryLayout {
    let edges: Edge.Set
    let padding: CGFloat
    
    func sizeThatFits(_ proposal: ProposedSize, element: some LayoutElementSizeProvider) -> CGSize {
        element.sizeThatFits(self.childProposal(for: proposal)).inset(edges: self.edges, -self.padding)
    }
    
    func place(_ element: some LayoutElement, in frame: CGRect) {
        let childFrame = frame.inset(edges: self.edges, self.padding)
                                     
        element.place(
            at: childFrame.center,
            anchor: .center,
            proposal: self.childProposal(for: self.childProposal(for: ProposedSize(size: frame.size)))
        )
    }
    
    private func childProposal(for proposal: ProposedSize) -> ProposedSize {
        let size = proposal
            .replacingUnspecifiedDimensions(by: .zero)
            .inset(edges: self.edges, self.padding)
        
        return ProposedSize(
            width: proposal.width == nil ? nil : size.width,
            height: proposal.height == nil ? nil : size.height
        )
    }
}

extension CGSize {
    func inset(edges: Edge.Set, _ inset: CGFloat) -> CGSize {
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
    func inset(edges: Edge.Set, _ inset: CGFloat) -> CGRect {
        let size = self.size.inset(edges: edges, inset)
        
        let origin = CGPoint(
            x: self.origin.x + (edges.contains(.left) ? inset : 0),
            y: self.origin.y + (edges.contains(.top) ? inset : 0)
        )
        
        return CGRect(origin: origin, size: size)
    }
}
