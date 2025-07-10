import CoreGraphics
import OpenLayoutCore

extension LayoutItem {
    public func fixedSize() -> some LayoutItem {
        self.fixedSize(horizontal: true, vertical: true)
    }
    
    public func fixedSize(horizontal: Bool, vertical: Bool) -> some LayoutItem {
        UnaryContainerItem(
            layout: FixedSizeLayout(horizontal: horizontal, vertical: vertical),
            child: self
        )
    }
}
