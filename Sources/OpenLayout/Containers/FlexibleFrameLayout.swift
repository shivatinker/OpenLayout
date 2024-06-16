//
//  FlexibleFrameLayout.swift
//
//
//  Created by Andrii Zinoviev on 13.06.2024.
//

import CoreGraphics

extension View {
    @available(*, deprecated, message: "Please pass one or more parameters")
    func frame() -> some View {
        self
    }
    
    @available(*, deprecated, message: "Please pass one or more dimension parameters")
    func frame(alignment: Alignment) -> some View {
        self
    }
    
    @_disfavoredOverload
    func frame(
        minWidth: CGFloat? = nil,
        maxWidth: CGFloat? = nil,
        idealWidth: CGFloat? = nil,
        minHeight: CGFloat? = nil,
        maxHeight: CGFloat? = nil,
        idealHeight: CGFloat? = nil,
        alignment: Alignment = .center
    ) -> some View {
        FlexibleFrameLayout(
            minWidth: minWidth,
            maxWidth: maxWidth,
            idealWidth: idealWidth,
            minHeight: minHeight,
            maxHeight: maxHeight,
            idealHeight: idealHeight,
            alignment: alignment
        ) {
            self
        }
    }
}

private struct FlexibleFrameLayout: UnaryLayout {
    private static let defaultSize = CGSize(width: 10, height: 10)
    
    let minWidth: CGFloat?
    let maxWidth: CGFloat?
    let idealWidth: CGFloat?
    
    let minHeight: CGFloat?
    let maxHeight: CGFloat?
    let idealHeight: CGFloat?
    
    let alignment: Alignment
    
    func sizeThatFits(_ proposal: ProposedSize, element: some LayoutElementSizeProvider) -> CGSize {
        self.constrained(
            proposal.replacingUnspecifiedDimensions(
                by: CGSize(
                    width: self.idealWidth ?? Self.defaultSize.width,
                    height: self.idealHeight ?? Self.defaultSize.height
                )
            )
        )
    }
    
    func place(_ element: some LayoutElement, in frame: CGRect) {
        let proposal = ProposedSize(size: self.constrained(frame.size))
        
        element.place(
            at: self.alignment.anchorPoint(in: frame),
            anchor: self.alignment,
            proposal: proposal
        )
    }
    
    private func constrained(_ size: CGSize) -> CGSize {
        CGSize(
            width: self.constrained(size.width, minValue: self.minWidth, maxValue: self.maxWidth),
            height: self.constrained(size.height, minValue: self.minHeight, maxValue: self.maxHeight)
        )
    }
    
    private func constrained(_ value: CGFloat, minValue: CGFloat?, maxValue: CGFloat?) -> CGFloat {
        var result = value
        
        if let minValue {
            result = max(result, minValue)
        }
        
        if let maxValue {
            result = min(result, maxValue)
        }
        
        return result
    }
}
