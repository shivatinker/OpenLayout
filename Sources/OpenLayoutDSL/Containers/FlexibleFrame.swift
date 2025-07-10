import CoreGraphics
import OpenLayoutCore

extension LayoutItem {
    @available(*, unavailable, message: "Please pass at least one dimension parameter")
    public func frame() -> some LayoutItem {
        fatalError("Please pass at least one dimension parameter")
    }
    
    @available(*, unavailable, message: "Please pass at least one dimension parameter")
    public func frame(alignment: Alignment) -> some LayoutItem {
        fatalError("Please pass at least one dimension parameter")
    }
    
    @_disfavoredOverload
    public func frame(
        minWidth: CGFloat? = nil,
        maxWidth: CGFloat? = nil,
        idealWidth: CGFloat? = nil,
        minHeight: CGFloat? = nil,
        maxHeight: CGFloat? = nil,
        idealHeight: CGFloat? = nil,
        alignment: Alignment = .center
    ) -> some LayoutItem {
        UnaryContainerItem(
            layout: FlexibleFrameLayout(
                minWidth: minWidth,
                maxWidth: maxWidth,
                idealWidth: idealWidth,
                minHeight: minHeight,
                maxHeight: maxHeight,
                idealHeight: idealHeight,
                alignment: alignment
            ),
            child: self
        )
    }
}
