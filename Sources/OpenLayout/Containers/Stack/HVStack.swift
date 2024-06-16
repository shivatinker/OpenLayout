//
//  HVStack.swift
//
//
//  Created by Andrii Zinoviev on 16.06.2024.
//

import CoreGraphics

protocol HVStack: Layout {}

extension HVStack {
    static var defaultSpacing: CGFloat { 8 }
}
