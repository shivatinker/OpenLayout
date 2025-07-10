//
//  StackLayoutEngine.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 10.07.2025.
//

import CoreGraphics

enum StackAlignment {
    case min
    case center
    case max
}

struct StackLayoutEngine {
    let spacing: CGFloat
    let axis: Axis
    let alignment: StackAlignment
    
    var crossAxis: Axis {
        self.axis.crossAxis
    }
    
    func sizeThatFits(
        _ proposal: ProposedSize,
        children: [some LayoutSizeProvider]
    ) -> CGSize {
        guard let availableLength = proposal.length(self.axis) else {
            // Just use ideal lengths for children
            let proposal = ProposedSize(
                axis: self.axis,
                length: nil,
                crossLength: proposal.length(self.crossAxis)
            )
            
            return self.sizeThatFits(
                childrenSizes: children.map { $0.sizeThatFits(proposal) }
            )
        }
        
        let layout = self.layout(
            children: children,
            availableLength: availableLength,
            crossLengthProposal: proposal.length(self.crossAxis)
        )
        
        return self.sizeThatFits(childrenSizes: layout.map(\.size))
    }
    
    private func sizeThatFits(childrenSizes: [CGSize]) -> CGSize {
        let totalSpacing = self.spacing * CGFloat(childrenSizes.count - 1)
        
        return CGSize(
            axis: self.axis,
            length: childrenSizes.map { $0.length(self.axis) }.reduce(0, +) + totalSpacing,
            crossLength: childrenSizes.map { $0.length(self.crossAxis) }.reduce(0, max)
        )
    }
    
    func placeChildren(
        _ children: inout [some LayoutElement],
        in frame: CGRect
    ) {
        let layout = self.layout(
            children: children,
            availableLength: frame.length(self.axis),
            crossLengthProposal: frame.length(self.crossAxis)
        )
        
        var cursor = frame.origin
        
        for (index, element) in layout.enumerated() {
            self.placeChild(
                &children[index],
                cursor: cursor,
                crossAxisLength: frame.length(self.crossAxis),
                element: element
            )
            
            cursor.modifyCoordinate(self.axis) {
                $0 += element.size.length(self.axis) + self.spacing
            }
        }
    }
    
    private func placeChild(
        _ child: inout some LayoutElement,
        cursor: CGPoint,
        crossAxisLength: CGFloat,
        element: CalculatedElement,
    ) {
        child.place(
            at: CGPoint(
                self.axis,
                coordinate: cursor.coordinate(self.axis) + element.size.length(self.axis) / 2.0,
                crossCoordinate: self.placementCrossCoordinate(
                    coordinate: cursor.coordinate(self.crossAxis),
                    elementCrossAxisLength: element.size.length(self.crossAxis),
                    crossAxisLength: crossAxisLength
                )
            ),
            anchor: .center,
            proposal: element.proposal
        )
    }
    
    private func placementCrossCoordinate(
        coordinate: CGFloat,
        elementCrossAxisLength: CGFloat,
        crossAxisLength: CGFloat
    ) -> CGFloat {
        switch self.alignment {
        case .min:
            coordinate + elementCrossAxisLength / 2.0

        case .center:
            coordinate + crossAxisLength / 2.0

        case .max:
            coordinate + crossAxisLength - elementCrossAxisLength / 2.0
        }
    }
    
    private struct CalculatedElement {
        let proposal: ProposedSize
        let size: CGSize
    }
    
    private func layout(
        children: [some LayoutSizeProvider],
        availableLength: CGFloat,
        crossLengthProposal: CGFloat?
    ) -> [CalculatedElement] {
        let sortedIndices = children
            .map { self.flexibility(for: $0, crossLengthProposal: crossLengthProposal) }
            .enumerated()
            .sorted { $0.1 < $1.1 }
            .map(\.offset)
        
        var result: [CalculatedElement] = Array(
            repeating: CalculatedElement(proposal: .unspecified, size: .zero),
            count: children.count
        )
        
        var remainingCount = children.count
        var remainingLength = availableLength
        
        for index in sortedIndices {
            let element = children[index]
            
            precondition(remainingCount > 0)
            let totalRemainingSpacing: CGFloat = self.spacing * (CGFloat(remainingCount) - 1)
            
            let remainingLengthWithoutSpacing = max(remainingLength - totalRemainingSpacing, 0.0)
            
            let proposal = ProposedSize(
                axis: self.axis,
                length: remainingLengthWithoutSpacing / CGFloat(remainingCount),
                crossLength: crossLengthProposal
            )
            
            let size = element.sizeThatFits(proposal)
            
            result[index] = CalculatedElement(
                proposal: proposal,
                size: size
            )
            
            remainingLength = max(remainingLength - size.length(self.axis) - self.spacing, 0)
            remainingCount -= 1
        }
        
        return result
    }
    
    private func flexibility(
        for element: LayoutSizeProvider,
        crossLengthProposal: CGFloat?
    ) -> CGFloat {
        let minLength = self.length(
            for: element,
            lengthProposal: 0,
            crossLengthProposal: crossLengthProposal
        )
        
        let maxLength = self.length(
            for: element,
            lengthProposal: .infinity,
            crossLengthProposal: crossLengthProposal
        )
        
        return maxLength - minLength
    }
    
    private func length(
        for element: LayoutSizeProvider,
        lengthProposal: CGFloat?,
        crossLengthProposal: CGFloat?
    ) -> CGFloat {
        element.sizeThatFits(
            ProposedSize(
                axis: self.axis,
                length: lengthProposal,
                crossLength: crossLengthProposal
            )
        ).length(self.axis)
    }
}

extension CGPoint {
    func coordinate(_ axis: Axis) -> CGFloat {
        switch axis {
        case .horizontal:
            self.x
            
        case .vertical:
            self.y
        }
    }
    
    mutating func modifyCoordinate(
        _ axis: Axis,
        _ body: (inout CGFloat) -> Void
    ) {
        switch axis {
        case .horizontal:
            body(&self.x)
            
        case .vertical:
            body(&self.y)
        }
    }
    
    init(_ axis: Axis, coordinate: CGFloat, crossCoordinate: CGFloat) {
        switch axis {
        case .horizontal:
            self.init(x: coordinate, y: crossCoordinate)
            
        case .vertical:
            self.init(x: crossCoordinate, y: coordinate)
        }
    }
}

extension CGRect {
    func length(_ axis: Axis) -> CGFloat {
        switch axis {
        case .horizontal:
            self.width
            
        case .vertical:
            self.height
        }
    }
}

extension ProposedSize {
    func length(_ axis: Axis) -> CGFloat? {
        switch axis {
        case .horizontal:
            self.width
            
        case .vertical:
            self.height
        }
    }
}

extension ProposedSize {
    init(axis: Axis, length: CGFloat?, crossLength: CGFloat?) {
        switch axis {
        case .horizontal:
            self.init(width: length, height: crossLength)
            
        case .vertical:
            self.init(width: crossLength, height: length)
        }
    }
}

extension CGSize {
    func length(_ axis: Axis) -> CGFloat {
        switch axis {
        case .horizontal:
            self.width
            
        case .vertical:
            self.height
        }
    }
    
    init(axis: Axis, length: CGFloat, crossLength: CGFloat) {
        switch axis {
        case .horizontal:
            self.init(width: length, height: crossLength)
            
        case .vertical:
            self.init(width: crossLength, height: length)
        }
    }
}
