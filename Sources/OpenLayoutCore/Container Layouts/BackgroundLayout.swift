import CoreGraphics

public struct BackgroundLayout: Layout {
    public init() {}
    
    public func sizeThatFits(
        _ proposal: ProposedSize,
        children: [some LayoutSizeProvider]
    ) -> CGSize {
        // Should have exactly 2 children: [background, mainContent]
        guard children.count == 2 else {
            assertionFailure("BackgroundLayout expects exactly 2 children")
            return .zero
        }
        
        let mainContent = children[1]
        
        // Background should always propose the size of the main view
        // So we return the main content's size, not the background's size
        return mainContent.sizeThatFits(proposal)
    }
    
    public func placeChildren(
        in rect: CGRect,
        children: inout [some LayoutElement]
    ) {
        guard children.count == 2 else {
            assertionFailure("BackgroundLayout expects exactly 2 children")
            return
        }
        
        // Place the background first (behind the main content)
        children[0].place(
            at: rect.center,
            anchor: .center,
            proposal: ProposedSize(rect.size)
        )
        
        // Then place the main content on top
        children[1].place(
            at: rect.center,
            anchor: .center,
            proposal: ProposedSize(rect.size)
        )
    }
} 