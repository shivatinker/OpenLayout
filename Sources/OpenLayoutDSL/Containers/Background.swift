import OpenLayoutCore

extension LayoutItem {
    public func background(_ background: some LayoutItem) -> some LayoutItem {
        ContainerItem(
            layout: BackgroundLayout(),
            children: [background, self]
        )
    }
} 