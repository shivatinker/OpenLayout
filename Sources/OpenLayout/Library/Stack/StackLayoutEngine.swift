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
    let majorAxis: Axis
    let alignment: StackAlignment

    var minorAxis: Axis {
        self.majorAxis.perpendicular
    }

    func sizeThatFits(
        _ proposal: ProposedSize,
        children: [any ChildMeasurement]
    ) -> CGSize {
        guard let availableLength = proposal.length(self.majorAxis) else {
            let childProposal = ProposedSize(
                axis: self.majorAxis,
                length: nil,
                minorLength: proposal.length(self.minorAxis)
            )

            return self.sizeThatFits(
                childrenSizes: children.map { $0.sizeThatFits(proposal: childProposal) }
            )
        }

        let layout = self.layout(
            children: children,
            availableLength: availableLength,
            minorLengthProposal: proposal.length(self.minorAxis)
        )

        return self.sizeThatFits(childrenSizes: layout.map(\.size))
    }

    private func sizeThatFits(childrenSizes: [CGSize]) -> CGSize {
        let totalSpacing = self.spacing * CGFloat(childrenSizes.count - 1)

        return CGSize(
            axis: self.majorAxis,
            majorLength: childrenSizes.map { $0.length(self.majorAxis) }.reduce(0, +) + totalSpacing,
            minorLength: childrenSizes.map { $0.length(self.minorAxis) }.reduce(0, max)
        )
    }

    func placeChildren(
        _ children: [any ChildPlacement],
        in frame: CGRect
    ) {
        let layout = self.layout(
            children: children,
            availableLength: frame.length(self.majorAxis),
            minorLengthProposal: frame.length(self.minorAxis)
        )

        var cursor = frame.origin

        for (index, element) in layout.enumerated() {
            self.placeChild(
                children[index],
                cursor: cursor,
                minorAxisLength: frame.length(self.minorAxis),
                element: element
            )

            cursor.modifyCoordinate(self.majorAxis) {
                $0 += element.size.length(self.majorAxis) + self.spacing
            }
        }
    }

    private func placeChild(
        _ child: some ChildPlacement,
        cursor: CGPoint,
        minorAxisLength: CGFloat,
        element: CalculatedElement
    ) {
        child.place(
            at: CGPoint(
                self.majorAxis,
                coordinate: cursor.coordinate(self.majorAxis) + element.size.length(self.majorAxis) / 2.0,
                crossCoordinate: self.placementMinorCoordinate(
                    coordinate: cursor.coordinate(self.minorAxis),
                    elementMinorAxisLength: element.size.length(self.minorAxis),
                    minorAxisLength: minorAxisLength
                )
            ),
            anchor: .center,
            proposal: element.proposal
        )
    }

    private func placementMinorCoordinate(
        coordinate: CGFloat,
        elementMinorAxisLength: CGFloat,
        minorAxisLength: CGFloat
    ) -> CGFloat {
        switch self.alignment {
        case .min:
            coordinate + elementMinorAxisLength / 2.0
        case .center:
            coordinate + minorAxisLength / 2.0
        case .max:
            coordinate + minorAxisLength - elementMinorAxisLength / 2.0
        }
    }

    private struct CalculatedElement {
        let proposal: ProposedSize
        let size: CGSize
    }

    private func layout(
        children: [any ChildMeasurement],
        availableLength: CGFloat,
        minorLengthProposal: CGFloat?
    ) -> [CalculatedElement] {
        struct Group {
            let priority: Int
            let indices: [Int]
        }

        let groups = Dictionary(grouping: children.indices) { children[$0].layoutPriority() }
            .map { Group(priority: $0.key, indices: $0.value) }
            .sorted { $0.priority > $1.priority }

        var result = [CalculatedElement](
            repeating: CalculatedElement(proposal: .unspecified, size: .zero),
            count: children.count
        )

        var remainingLength = availableLength
        var remainingCount = children.count

        for (index, group) in groups.enumerated() {
            let lowerMinLength = groups[(index + 1)...]
                .flatMap(\.indices)
                .reduce(0.0) { total, idx in
                    total + self.minLength(of: children[idx], minorLengthProposal: minorLengthProposal)
                }

            let sortedIndices = group.indices.sorted {
                self.flexibility(for: children[$0], minorLengthProposal: minorLengthProposal) <
                    self.flexibility(for: children[$1], minorLengthProposal: minorLengthProposal)
            }

            var groupCount = sortedIndices.count

            for index in sortedIndices {
                let spacingReservation = self.spacing * CGFloat(remainingCount - 1)
                let proposedLength = max(remainingLength - lowerMinLength - spacingReservation, 0) / CGFloat(groupCount)

                let proposal = ProposedSize(axis: self.majorAxis, length: proposedLength, minorLength: minorLengthProposal)
                let size = children[index].sizeThatFits(proposal: proposal)

                result[index] = CalculatedElement(proposal: proposal, size: size)
                remainingLength = max(remainingLength - size.length(self.majorAxis) - self.spacing, 0)
                remainingCount -= 1
                groupCount -= 1
            }
        }

        return result
    }

    private func minLength(of element: any ChildMeasurement, minorLengthProposal: CGFloat?) -> CGFloat {
        element.sizeThatFits(proposal: ProposedSize(
            axis: self.majorAxis, length: 0, minorLength: minorLengthProposal
        )).length(self.majorAxis)
    }

    private func flexibility(
        for element: any ChildMeasurement,
        minorLengthProposal: CGFloat?
    ) -> CGFloat {
        let minLength = element.sizeThatFits(proposal: ProposedSize(
            axis: self.majorAxis, length: 0, minorLength: minorLengthProposal
        )).length(self.majorAxis)

        let maxLength = element.sizeThatFits(proposal: ProposedSize(
            axis: self.majorAxis, length: .infinity, minorLength: minorLengthProposal
        )).length(self.majorAxis)

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

    init(axis: Axis, length: CGFloat?, minorLength: CGFloat?) {
        switch axis {
        case .horizontal: self.init(width: length, height: minorLength)
        case .vertical: self.init(width: minorLength, height: length)
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

    init(axis: Axis, majorLength: CGFloat, minorLength: CGFloat) {
        switch axis {
        case .horizontal: self.init(width: majorLength, height: minorLength)
        case .vertical: self.init(width: minorLength, height: majorLength)
        }
    }
}
