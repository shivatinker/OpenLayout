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
                        Rect(5).padding(6).background(Rect(6))
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
                .background(Rect(21))
            }
        }
        .setSize(CGSize(width: 300, height: 250))
        .check()
    }

    // Non-center stack alignments — tricky due to .left/.right → .leading/.trailing mapping
    func testStackAlignments() {
        SwiftUITest {
            VStack(spacing: 10) {
                HStack(alignment: .top, spacing: 6) {
                    Rect(1).frame(height: 20)
                    Rect(2).frame(height: 50)
                    Rect(3).frame(height: 35)
                }
                HStack(alignment: .bottom, spacing: 6) {
                    Rect(4).frame(height: 20)
                    Rect(5).frame(height: 50)
                    Rect(6).frame(height: 35)
                }
                VStack(alignment: .left, spacing: 4) {
                    Rect(7).frame(width: 50)
                    Rect(8).frame(width: 80)
                    Rect(9).frame(width: 30)
                }
                VStack(alignment: .right, spacing: 4) {
                    Rect(10).frame(width: 50)
                    Rect(11).frame(width: 80)
                    Rect(12).frame(width: 30)
                }
            }
        }
        .setSize(CGSize(width: 200, height: 400))
        .check()
    }

    // fixedSize() preventing expansion in stacks, and overriding flexible frame constraints
    func testFixedSizeInStack() {
        SwiftUITest {
            VStack(spacing: 8) {
                // fixedSize locks a child to intrinsic size inside HStack
                HStack(spacing: 6) {
                    Rect(1).fixedSize()
                    Rect(2)
                    Rect(3).fixedSize()
                }
                // fixedSize overrides flexible frame — fixedSize wins
                HStack(spacing: 6) {
                    Rect(4).fixedSize().frame(minWidth: 50, maxWidth: 80)
                    Rect(5).frame(minWidth: 50, maxWidth: 80)
                }
                // fixedSize horizontal only
                HStack(spacing: 6) {
                    Rect(6).fixedSize(horizontal: true, vertical: false)
                    Rect(7).fixedSize(horizontal: false, vertical: true)
                    Rect(8)
                }
            }
        }
        .setSize(CGSize(width: 200, height: 200))
        .check()
    }

    // Nested backgrounds and background behind containers with padding
    func testBackgroundVariants() {
        SwiftUITest {
            VStack(spacing: 10) {
                // Chained backgrounds — outermost background wraps all
                Rect(1)
                    .padding(6)
                    .background(Rect(2))
                    .padding(6)
                    .background(Rect(3))
                // Background behind HStack with padding — background extends beyond children
                HStack(spacing: 4) {
                    Rect(4).frame(width: 30, height: 30)
                    Rect(5).frame(width: 30, height: 30)
                }
                .padding(8)
                .background(Rect(6))
                // Background where background itself has padding inward
                Rect(7)
                    .background(
                        Rect(8).padding(6)
                    )
                // Background behind VStack
                VStack(spacing: 4) {
                    Rect(9).frame(width: 50)
                    Rect(10).frame(width: 70)
                }
                .padding(6)
                .background(Rect(11))
            }
        }
        .setSize(CGSize(width: 200, height: 350))
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
