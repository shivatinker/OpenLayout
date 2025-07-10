import CoreGraphics

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
