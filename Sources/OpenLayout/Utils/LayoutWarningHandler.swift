//
//  LayoutWarningHandler.swift
//
//
//  Created by Andrii Zinoviev on 16.06.2024.
//

import CoreGraphics

enum LayoutWarning {
    case invalidFrame(frame: CGRect)
    case overflow(parentFrame: CGRect, childFrame: CGRect)
}

protocol LayoutWarningHandler {
    func handle(_ warning: LayoutWarning)
}

struct DefaultLayoutWarningHandler: LayoutWarningHandler {
    func handle(_ warning: LayoutWarning) {
        switch warning {
        case let .invalidFrame(frame):
            print("WARNING: Invalid frame produced by layout system: \(frame)")
            
        case let .overflow(parentFrame, childFrame):
            print("WARNING: Layout overflow, parent frame: \(parentFrame), child frame: \(childFrame)")
        }
    }
}
