//
//  RectDrawable.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 19.05.2026.
//

import CoreGraphics
import OpenLayout

struct RectDrawable {
    let id: Int
    let frame: CGRect
}

func collectRects(from node: LayoutNode, into result: inout [RectDrawable]) {
    if let id = node.leafData as? Int, let frame = node.frame {
        result.append(RectDrawable(id: id, frame: frame))
    }
    for child in node.children {
        collectRects(from: child, into: &result)
    }
}
