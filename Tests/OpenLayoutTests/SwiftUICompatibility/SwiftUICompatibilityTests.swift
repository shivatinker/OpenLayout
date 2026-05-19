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

    func testBig() {
        SwiftUITest {
            HStack(spacing: 6) {
                VStack(spacing: 6) {
                    Rect(1).frame(width: 40, height: 40)
                    HStack(spacing: 4) {
                        Rect(2).frame(minWidth: 10, maxWidth: 30)
                        Rect(3).frame(minWidth: 10, maxWidth: 30)
                    }
                    Rect(4).padding(.horizontal, 8)
                    HStack(spacing: 4) {
                        Rect(5).background(Rect(6))
                        VStack(spacing: 4) {
                            Rect(7).fixedSize()
                            Rect(8)
                        }
                    }
                    Rect(9).frame(height: 12).padding(4)
                    Rect(10).frame(minHeight: 8, maxHeight: 24)
                }
                VStack(spacing: 6) {
                    HStack(spacing: 4) {
                        Rect(11).frame(width: 20, height: 20)
                        Rect(12).frame(width: 20, height: 20)
                        Rect(13).frame(width: 20, height: 20)
                    }
                    Rect(14).frame(minWidth: 30, maxWidth: .infinity, minHeight: 20)
                    HStack(spacing: 4) {
                        VStack(spacing: 4) {
                            Rect(15).padding(.top, 6)
                            Rect(16).padding(.bottom, 6)
                        }
                        Rect(17).background(
                            Rect(18).padding(4)
                        )
                    }
                    HStack(spacing: 4) {
                        Rect(19).frame(maxWidth: .infinity)
                        Rect(20).frame(maxWidth: .infinity)
                    }
                }
            }
        }
        .setSize(CGSize(width: 300, height: 250))
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
