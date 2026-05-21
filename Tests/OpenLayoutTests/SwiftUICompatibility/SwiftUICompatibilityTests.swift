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
    
    func testMixedHStack() {
        SwiftUITest {
            HStack(spacing: 10) {
                Rect(1).frame(minWidth: 30, maxWidth: 100)
                Rect(2).frame(width: 10)
            }
        }
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

    func testLargeVStack() {
        SwiftUITest {
            VStack(spacing: 6) {
                Rect(1).frame(height: 20) // fixed height
                Rect(2) // fully flexible
                Rect(3).frame(minHeight: 10, maxHeight: 30) // clamped flex
                Rect(4).fixedSize() // intrinsic only
                Rect(5).padding(.vertical, 8) // padded flex
                Rect(6).frame(height: 16).padding(.horizontal, 12) // fixed + h-pad
                Rect(7).frame(minHeight: 20, maxHeight: .infinity) // unbounded flex
                Rect(8).frame(height: 24) // fixed height
                Rect(9).frame(minHeight: 8, maxHeight: 20) // clamped flex
                Rect(10).fixedSize(horizontal: false, vertical: true) // v-fixed only
                Rect(11).padding(4).frame(minHeight: 12, maxHeight: 40) // padded then clamped
                Rect(12).frame(maxHeight: .infinity) // unbounded flex
            }
        }
        .setSize(CGSize(width: 160, height: 400))
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
    
    func testStackIdealSize() {
        SwiftUITest {
            HStack(spacing: 8) {
                // VStack with fixedSize — ignores proposed height, uses sum of children's ideal heights.
                // Flexible frames resolve to their ideal (min) size when proposed nil.
                VStack(spacing: 4) {
                    Rect(1).frame(width: 40, height: 20)
                    Rect(2).frame(minHeight: 10, maxHeight: 60)
                    Rect(3).frame(width: 30, height: 15)
                }
                .fixedSize()

                VStack(spacing: 4) {
                    // HStack with fixedSize — ignores proposed width, uses sum of children's ideal widths.
                    HStack(spacing: 4) {
                        Rect(4).frame(width: 20, height: 20)
                        Rect(5).frame(minWidth: 10, maxWidth: 100)
                        Rect(6).frame(width: 15, height: 20)
                    }
                    .fixedSize()

                    // Flexible view fills remaining space in the column
                    Rect(7).frame(minHeight: 20, maxHeight: .infinity)
                }

                // fixedSize(horizontal:vertical:) — only fix one axis at a time
                VStack(spacing: 4) {
                    Rect(8).frame(minWidth: 20, maxWidth: 80).fixedSize(horizontal: true, vertical: false)
                    Rect(9).frame(minHeight: 20, maxHeight: 80).fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .setSize(CGSize(width: 300, height: 200))
        .check()
    }

    func testSpacer() {
        SwiftUITest {
            VStack(spacing: 0) {
                Rect(1).fixedSize()
                Spacer()
                Rect(2)
            }
        }
        .check()
    }

    func testMultipleSpacers() {
        SwiftUITest {
            VStack(spacing: 8) {
                // Three spacers in one HStack — split remaining width into three equal gaps
                HStack(spacing: 0) {
                    Spacer()
                    Rect(1).frame(width: 20, height: 20)
                    Spacer()
                    Rect(2).frame(width: 30, height: 20)
                    Spacer()
                }

                // Spacers with explicit minLength flanking a flexible view
                HStack(spacing: 4) {
                    Rect(3).fixedSize()
                    Spacer(minLength: 12)
                    Rect(4).frame(maxWidth: .infinity, minHeight: 20)
                    Spacer(minLength: 12)
                    Rect(5).fixedSize()
                }

                // Three columns, each with spacers in different positions
                HStack(spacing: 8) {
                    // Spacer at bottom — content floats to top
                    VStack(spacing: 4) {
                        Rect(6).frame(height: 20)
                        Rect(7).frame(height: 20)
                        Spacer()
                    }

                    // Spacer at top — content floats to bottom
                    VStack(spacing: 4) {
                        Spacer()
                        Rect(8).frame(height: 20)
                        Rect(9).frame(height: 20)
                    }

                    // Two spacers sandwiching a fixed view in the center
                    VStack(spacing: 0) {
                        Spacer()
                        Rect(10).fixedSize()
                        Spacer()
                    }
                }

                // Horizontal spacers inside a VStack column, mixing with padding
                VStack(spacing: 4) {
                    HStack(spacing: 0) {
                        Rect(11).frame(width: 30, height: 16)
                        Spacer(minLength: 0)
                        Rect(12).frame(width: 40, height: 16)
                        Spacer(minLength: 0)
                        Rect(13).frame(width: 20, height: 16)
                    }
                    HStack(spacing: 0) {
                        Spacer()
                        Rect(14).frame(width: 50, height: 16)
                    }
                    HStack(spacing: 0) {
                        Rect(15).frame(width: 50, height: 16)
                        Spacer()
                    }
                }
            }
        }
        .setSize(CGSize(width: 300, height: 300))
        .check()
    }
}
