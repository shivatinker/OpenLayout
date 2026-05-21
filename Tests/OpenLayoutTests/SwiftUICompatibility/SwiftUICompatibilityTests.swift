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

    func testPaddingVariants() {
        SwiftUITest {
            VStack(spacing: 8) {
                // Per-edge padding
                HStack(spacing: 6) {
                    Rect(1).padding(.top, 12)
                    Rect(2).padding(.bottom, 12)
                    Rect(3).padding(.left, 20)
                    Rect(4).padding(.right, 20)
                }
                // Multi-edge sets
                HStack(spacing: 6) {
                    Rect(5).padding([.top, .left], 10)
                    Rect(6).padding([.bottom, .right], 10)
                    Rect(7).padding(.horizontal, 15)
                    Rect(8).padding(.vertical, 15)
                }
                // Nested padding accumulates
                Rect(9).padding(.left, 20).padding(.right, 10).padding(.vertical, 8)
                // Padding around fixed-size children
                HStack(spacing: 6) {
                    Rect(10).frame(width: 30, height: 20).padding(8)
                    Rect(11).frame(width: 40, height: 25).padding(.horizontal, 6)
                }
            }
        }
        .setSize(CGSize(width: 300, height: 300))
        .check()
    }

    func testFrameVariants() {
        SwiftUITest {
            VStack(spacing: 8) {
                // Fixed frame alignment
                HStack(spacing: 6) {
                    Rect(1).frame(width: 30, height: 20).frame(width: 60, height: 60, alignment: .topLeft)
                    Rect(2).frame(width: 30, height: 20).frame(width: 60, height: 60, alignment: .bottomRight)
                    Rect(3).frame(width: 30, height: 20).frame(width: 60, height: 60, alignment: .top)
                }
                // Flexible frame clamping
                HStack(spacing: 6) {
                    Rect(4).frame(minWidth: 20, maxWidth: 50)
                    Rect(5).frame(minHeight: 20, maxHeight: 40)
                    Rect(6).frame(minWidth: 10, maxWidth: 30, minHeight: 10, maxHeight: 30)
                }
                // maxWidth: .infinity to fill available space
                HStack(spacing: 6) {
                    Rect(7).frame(width: 40)
                    Rect(8).frame(maxWidth: .infinity)
                }
                // Nested fixed frames — outer wins for placement, inner wins for size
                HStack(spacing: 6) {
                    Rect(9).frame(width: 50, height: 30).frame(width: 30, height: 50)
                    Rect(10).frame(width: 40, height: 20).frame(width: 60, height: 40, alignment: .bottomRight)
                }
            }
        }
        .setSize(CGSize(width: 300, height: 250))
        .check()
    }

    func testFixedSizeVariants() {
        SwiftUITest {
            VStack(spacing: 8) {
                // fixedSize both axes
                HStack(spacing: 8) {
                    Rect(1).fixedSize()
                    Rect(2).frame(maxWidth: .infinity)
                }
                // fixedSize axis order with padding — both orderings should produce same result
                HStack(spacing: 8) {
                    Rect(3).fixedSize().padding(10)
                    Rect(4).padding(10).fixedSize()
                }
                // fixedSize with flexible frame — fixedSize overrides the frame constraint
                HStack(spacing: 8) {
                    Rect(5).fixedSize().frame(minWidth: 50, maxWidth: 80)
                    Rect(6).frame(minWidth: 50, maxWidth: 80)
                }
                // per-axis fixedSize in an HStack
                HStack(spacing: 8) {
                    Rect(7).fixedSize(horizontal: true, vertical: false)
                    Rect(8).fixedSize(horizontal: false, vertical: true)
                    Rect(9)
                }
            }
        }
        .setSize(CGSize(width: 250, height: 250))
        .check()
    }

    func testBackgroundWithFrames() {
        SwiftUITest {
            VStack(spacing: 8) {
                // Background sized to flexible frame
                Rect(1)
                    .frame(minWidth: 40, maxWidth: 100, minHeight: 20, maxHeight: 60)
                    .background(Rect(2))
                // Background behind a stack with padding — background covers padding area too
                HStack(spacing: 4) {
                    Rect(3).frame(width: 30, height: 30)
                    Rect(4).frame(width: 30, height: 30)
                }
                .padding(10)
                .background(Rect(5))
                // Nested background with its own frame constraint
                Rect(6)
                    .background(Rect(7).frame(width: 20, height: 20))
                // Background with padding applied to the background layer
                Rect(8)
                    .padding(12)
                    .background(Rect(9))
                    .padding(6)
                    .background(Rect(10))
            }
        }
        .setSize(CGSize(width: 200, height: 300))
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
    
    func testFakeText() {
        SwiftUITest {
            VStack {
                FakeText(id: 1, size: 3300)
                FakeText(id: 2, size: 1200)
                FakeText(id: 3, size: 2200)
            }
        }
        .check()
    }
    
    func testBogusSwiftUIEmptyLayout() {
        SwiftUITest {
            HStack {
                FakeText(id: 1, size: 6000)
                Spacer()
                Rect(2).fixedSize()
            }
        }
        .check()
    }
    
    func testOrphanSpacer() {
        SwiftUITest {
            Spacer()
                .background(Rect(1))
        }
        .check()
    }
    
    func testSpacerFixedSize() {
        SwiftUITest {
            VStack {
                Spacer()
                    .background(Rect(1))
                    .fixedSize()
                
                Rect(2)
            }
        }
        .check()
    }
    
    func testOrphanSpacerFixedSize() {
        SwiftUITest {
            Spacer()
                .background(Rect(1))
                .fixedSize()
        }
        .check()
    }

    func testFakeTextComplex() {
        SwiftUITest {
            VStack(spacing: 8) {
                // Row 1: text beside a fixed icon — text wraps into the remaining width
                HStack(spacing: 8) {
                    Rect(1).frame(width: 32, height: 32)
                    VStack(spacing: 4) {
                        FakeText(id: 2, size: 6000)
                        FakeText(id: 3, size: 800)
                    }
                }

                // Row 2: two texts competing for width — equal share, different wrap heights
                HStack(spacing: 8) {
                    FakeText(id: 4, size: 3200)
                    FakeText(id: 5, size: 900)
                }

                // Row 3: text + spacer + badge — spacer pushes badge to trailing edge,
                // text gets the remaining width after the spacer minimum is reserved
                HStack(spacing: 6) {
                    FakeText(id: 6, size: 2400)
                    Spacer(minLength: 8)
                    Rect(7).frame(width: 24, height: 24)
                }

                // Row 4: fixed-size text — uses single-line ideal width regardless of container
                HStack(spacing: 8) {
                    FakeText(id: 8, size: 600).fixedSize()
                    Rect(9).frame(maxWidth: .infinity, minHeight: 20)
                }

                // Row 5: three texts with different sizes in a constrained HStack,
                // then the whole row wrapped in fixedSize so the HStack takes ideal height
                HStack(spacing: 6) {
                    FakeText(id: 10, size: 4000)
                    FakeText(id: 11, size: 1500)
                    FakeText(id: 12, size: 2500)
                }
                .fixedSize(horizontal: false, vertical: true)
            }
        }
        .setSize(CGSize(width: 300, height: 500))
        .check()
    }
}
