//
//  SwiftUICompatibilityTests.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 19.05.2026.
//

import AppKit
import CoreGraphics
import OpenLayout
import OpenLayoutDSL
@testable import Shapes
import SwiftUI
import XCTest

@MainActor
final class SwiftUICompatibilityTests: XCTestCase {
    func testSimple() {
        SwiftUITest {
            Rect(1).padding(.left, 10).padding(20)
        }.check()
    }
    
    func testRounding() {
        SwiftUITest {
            VStack(spacing: 10) {
                Rect(1)
                Rect(2)
                Rect(3)
            }
        }
        .setSize(CGSize(width: 100, height: 100))
        .check()
    }

    func testComplex() {
        SwiftUITest {
            VStack(spacing: 8) {
                HStack(spacing: 8) {
                    Rect(1)
                    Rect(2).frame(width: 30, height: 30)
                    Rect(3).padding(4)
                }
                HStack(spacing: 8) {
                    VStack(spacing: 4) {
                        Rect(4)
                        Rect(5).fixedSize()
                        Rect(6).frame(minWidth: 10, maxWidth: 40)
                    }
                    Rect(7).background(Rect(8))
                }
                HStack(spacing: 8) {
                    Rect(9).frame(width: 20).padding(.top, 6)
                    Rect(10).frame(minHeight: 20, maxHeight: 50, alignment: .bottom)
                }
            }
        }
        .setSize(CGSize(width: 200, height: 200))
        .check()
    }
}
