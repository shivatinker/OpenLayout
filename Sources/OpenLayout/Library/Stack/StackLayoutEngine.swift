//
//  StackLayoutEngine.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 19.05.2026.
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
        children: [any ChildMeasurement]
    ) -> CGSize {
        guard let availableLength = proposal.length(self.axis) else {
            let childProposal = ProposedSize(
                axis: self.axis,
                length: nil,
                crossLength: proposal.length(self.crossAxis)
            )
            
            return self.sizeThatFits(
                childrenSizes: children.map { $0.sizeThatFits(proposal: childProposal) }
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
        _ children: [any ChildPlacement],
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
                children[index],
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
        _ child: some ChildPlacement,
        cursor: CGPoint,
        crossAxisLength: CGFloat,
        element: CalculatedElement
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
        children: [any ChildMeasurement],
        availableLength: CGFloat,
        crossLengthProposal: CGFloat?
    ) -> [CalculatedElement] {
        // Group indices by priority, process highest-priority groups first.
        let groups = Dictionary(grouping: children.indices) { children[$0].layoutPriority() }
        let sortedPriorities = groups.keys.sorted(by: >)

        var result: [CalculatedElement] = Array(
            repeating: CalculatedElement(proposal: .unspecified, size: .zero),
            count: children.count
        )

        // remainingCount spans all groups and drives spacing reservation.
        var remainingCount = children.count
        var remainingLength = availableLength

        for (groupPosition, priority) in sortedPriorities.enumerated() {
            let groupIndices = groups[priority]!

            // Reserve the minimum space claimed by all lower-priority children
            // so that they can always satisfy their minimum size.
            let lowerPriorityMinLength = sortedPriorities[(groupPosition + 1)...]
                .flatMap { groups[$0]! }
                .reduce(0.0) { sum, idx in
                    sum + children[idx].sizeThatFits(proposal: ProposedSize(
                        axis: self.axis, length: 0, crossLength: crossLengthProposal
                    )).length(self.axis)
                }

            // Within the group, measure least-flexible children first.
            let sortedGroupIndices = groupIndices.sorted {
                self.flexibility(for: children[$0], crossLengthProposal: crossLengthProposal) <
                    self.flexibility(for: children[$1], crossLengthProposal: crossLengthProposal)
            }

            // Space is divided only among the children remaining in this group,
            // not across all remaining children, so higher-priority children
            // receive a larger share before lower-priority groups are considered.
            var groupRemainingCount = sortedGroupIndices.count

            for index in sortedGroupIndices {
                precondition(remainingCount > 0)
                let totalRemainingSpacing = self.spacing * (CGFloat(remainingCount) - 1)
                let remainingLengthWithoutSpacing = max(
                    remainingLength - lowerPriorityMinLength - totalRemainingSpacing, 0.0
                )

                let proposal = ProposedSize(
                    axis: self.axis,
                    length: remainingLengthWithoutSpacing / CGFloat(groupRemainingCount),
                    crossLength: crossLengthProposal
                )

                let size = children[index].sizeThatFits(proposal: proposal)
                result[index] = CalculatedElement(proposal: proposal, size: size)

                remainingLength = max(remainingLength - size.length(self.axis) - self.spacing, 0)
                remainingCount -= 1
                groupRemainingCount -= 1
            }
        }

        return result
    }

    private func flexibility(
        for element: any ChildMeasurement,
        crossLengthProposal: CGFloat?
    ) -> CGFloat {
        let minLength = element.sizeThatFits(proposal: ProposedSize(
            axis: self.axis, length: 0, crossLength: crossLengthProposal
        )).length(self.axis)

        let maxLength = element.sizeThatFits(proposal: ProposedSize(
            axis: self.axis, length: .infinity, crossLength: crossLengthProposal
        )).length(self.axis)

        return maxLength - minLength
    }
}

// MARK: - Axis helpers

extension CGPoint {
    func coordinate(_ axis: Axis) -> CGFloat {
        switch axis {
        case .horizontal: self.x
        case .vertical: self.y
        }
    }

    mutating func modifyCoordinate(_ axis: Axis, _ body: (inout CGFloat) -> Void) {
        switch axis {
        case .horizontal: body(&self.x)
        case .vertical: body(&self.y)
        }
    }

    init(_ axis: Axis, coordinate: CGFloat, crossCoordinate: CGFloat) {
        switch axis {
        case .horizontal: self.init(x: coordinate, y: crossCoordinate)
        case .vertical: self.init(x: crossCoordinate, y: coordinate)
        }
    }
}

extension CGRect {
    func length(_ axis: Axis) -> CGFloat {
        switch axis {
        case .horizontal: self.width
        case .vertical: self.height
        }
    }
}

extension ProposedSize {
    func length(_ axis: Axis) -> CGFloat? {
        switch axis {
        case .horizontal: self.width
        case .vertical: self.height
        }
    }

    init(axis: Axis, length: CGFloat?, crossLength: CGFloat?) {
        switch axis {
        case .horizontal: self.init(width: length, height: crossLength)
        case .vertical: self.init(width: crossLength, height: length)
        }
    }
}

extension CGSize {
    func length(_ axis: Axis) -> CGFloat {
        switch axis {
        case .horizontal: self.width
        case .vertical: self.height
        }
    }

    init(axis: Axis, length: CGFloat, crossLength: CGFloat) {
        switch axis {
        case .horizontal: self.init(width: length, height: crossLength)
        case .vertical: self.init(width: crossLength, height: length)
        }
    }
}
