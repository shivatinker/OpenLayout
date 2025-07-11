//
//  CustomLayoutItemTests.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 10.07.2025.
//

import OpenLayout
import XCTest

// MARK: - Custom Composite Layout Items

private struct Card: LayoutItem {
    let title: String
    let backgroundColor: String
    
    var body: some LayoutItem {
        VStack(alignment: .center, spacing: 2) {
            Rectangle().id(1).frame(width: 30, height: 8)
            Rectangle().id(2).frame(width: 25, height: 6)
            Rectangle().id(3).frame(width: 20, height: 4)
        }
        .padding(3)
        .frame(minWidth: 36, maxWidth: 40, minHeight: 25, maxHeight: 30)
    }
}

private struct ProfileCard: LayoutItem {
    let name: String
    let avatarSize: CGFloat
    
    var body: some LayoutItem {
        HStack(alignment: .center, spacing: 4) {
            Rectangle().id(4).frame(width: self.avatarSize, height: self.avatarSize)
            
            VStack(alignment: .left, spacing: 2) {
                Rectangle().id(5).frame(width: 20, height: 5)
                Rectangle().id(6).frame(width: 15, height: 3)
            }
        }
        .frame(minWidth: 30, maxWidth: 50)
        .padding(2)
    }
}

private struct Dashboard: LayoutItem {
    let showHeader: Bool
    
    var body: some LayoutItem {
        VStack(alignment: .center, spacing: 4) {
            if self.showHeader {
                Rectangle().id(7).frame(width: 60, height: 10)
            }
            
            HStack(alignment: .bottom, spacing: 6) {
                Card(title: "Stats", backgroundColor: "blue")
                ProfileCard(name: "John", avatarSize: 12)
            }
            
            Rectangle().id(8).frame(width: 50, height: 8)
        }
        .padding(4)
    }
}

private struct ResponsiveGrid: LayoutItem {
    let columns: Int
    let spacing: CGFloat
    
    var body: some LayoutItem {
        VStack(alignment: .center, spacing: self.spacing) {
            for row in 0..<self.columns {
                HStack(alignment: .center, spacing: self.spacing) {
                    for col in 0..<self.columns {
                        Rectangle()
                            .id(row * self.columns + col + 9)
                            .frame(width: 8, height: 8)
                    }
                }
            }
        }
        .padding(3)
    }
}

private struct AlignedCard: LayoutItem {
    let alignment: Alignment
    
    var body: some LayoutItem {
        VStack(alignment: .center, spacing: 2) {
            Rectangle().id(1).frame(width: 30, height: 8)
            Rectangle().id(2).frame(width: 25, height: 6)
            Rectangle().id(3).frame(width: 20, height: 4)
        }
        .frame(width: 40, height: 30, alignment: self.alignment)
    }
}

private struct AlignedProfile: LayoutItem {
    let alignment: Alignment
    
    var body: some LayoutItem {
        HStack(alignment: .center, spacing: 4) {
            Rectangle().id(4).frame(width: 15, height: 15)
            
            VStack(alignment: .left, spacing: 2) {
                Rectangle().id(5).frame(width: 20, height: 5)
                Rectangle().id(6).frame(width: 15, height: 3)
            }
        }
        .frame(width: 45, height: 25, alignment: self.alignment)
    }
}

// MARK: - Tests

@MainActor
final class CustomLayoutItemTests: XCTestCase {
    func testSimpleCardLayout() {
        Utils.assertLeafLayout(
            Card(title: "Test Card", backgroundColor: "red"),
            expectedLayout: """
            1: 35.0 39.0 30.0 8.0
            2: 37.5 49.0 25.0 6.0
            3: 40.0 57.0 20.0 4.0
            """
        )
    }
    
    func testProfileCardLayout() {
        Utils.assertLeafLayout(
            ProfileCard(name: "Alice", avatarSize: 15),
            expectedLayout: """
            4: 30.5 42.5 15.0 15.0
            5: 49.5 45.0 20.0 5.0
            6: 49.5 52.0 15.0 3.0
            """
        )
    }
    
    func testComplexDashboardLayout() {
        Utils.assertLeafLayout(
            Dashboard(showHeader: true),
            expectedLayout: """
            1: 9.0 40.0 30.0 8.0
            2: 11.5 50.0 25.0 6.0
            3: 14.0 58.0 20.0 4.0
            4: 55.0 52.0 12.0 12.0
            5: 71.0 53.0 20.0 5.0
            6: 71.0 60.0 15.0 3.0
            7: 20.0 22.0 60.0 10.0
            8: 25.0 70.0 50.0 8.0
            """
        )
    }
    
    func testResponsiveGridLayout() {
        Utils.assertLeafLayout(
            ResponsiveGrid(columns: 2, spacing: 2),
            expectedLayout: """
            9: 41.0 41.0 8.0 8.0
            10: 51.0 41.0 8.0 8.0
            11: 41.0 51.0 8.0 8.0
            12: 51.0 51.0 8.0 8.0
            """
        )
    }
    
    func testNestedCustomLayoutItems() {
        Utils.assertLeafLayout(
            VStack(alignment: .center, spacing: 6) {
                Card(title: "First", backgroundColor: "green")
                HStack(alignment: .center, spacing: 4) {
                    ProfileCard(name: "Bob", avatarSize: 10)
                    Card(title: "Second", backgroundColor: "purple")
                }
                ResponsiveGrid(columns: 2, spacing: 2)
            },
            expectedLayout: """
            1: 64.0 42.0 30.0 8.0
            2: 66.5 52.0 25.0 6.0
            3: 69.0 60.0 20.0 4.0
            4: 11.0 48.0 10.0 10.0
            5: 25.0 48.0 20.0 5.0
            6: 25.0 55.0 15.0 3.0
            9: 41.0 77.0 8.0 8.0
            10: 51.0 77.0 8.0 8.0
            11: 41.0 87.0 8.0 8.0
            12: 51.0 87.0 8.0 8.0
            """
        )
    }
    
    // MARK: - Alignment Tests
    
    func testVStackAlignments() {
        // Test VStack with different alignments
        Utils.assertLeafLayout(
            VStack(alignment: .left, spacing: 4) {
                Rectangle().id(1).frame(width: 20, height: 10)
                Rectangle().id(2).frame(width: 30, height: 8)
                Rectangle().id(3).frame(width: 15, height: 12)
            }
            .frame(width: 50, height: 40),
            expectedLayout: """
            1: 35.0 31.0 20.0 10.0
            2: 35.0 45.0 30.0 8.0
            3: 35.0 57.0 15.0 12.0
            """
        )
        
        Utils.assertLeafLayout(
            VStack(alignment: .center, spacing: 4) {
                Rectangle().id(1).frame(width: 20, height: 10)
                Rectangle().id(2).frame(width: 30, height: 8)
                Rectangle().id(3).frame(width: 15, height: 12)
            }
            .frame(width: 50, height: 40),
            expectedLayout: """
            1: 40.0 31.0 20.0 10.0
            2: 35.0 45.0 30.0 8.0
            3: 42.5 57.0 15.0 12.0
            """
        )
        
        Utils.assertLeafLayout(
            VStack(alignment: .right, spacing: 4) {
                Rectangle().id(1).frame(width: 20, height: 10)
                Rectangle().id(2).frame(width: 30, height: 8)
                Rectangle().id(3).frame(width: 15, height: 12)
            }
            .frame(width: 50, height: 40),
            expectedLayout: """
            1: 45.0 31.0 20.0 10.0
            2: 35.0 45.0 30.0 8.0
            3: 50.0 57.0 15.0 12.0
            """
        )
    }
    
    func testHStackAlignments() {
        // Test HStack with different alignments
        Utils.assertLeafLayout(
            HStack(alignment: .top, spacing: 4) {
                Rectangle().id(1).frame(width: 15, height: 20)
                Rectangle().id(2).frame(width: 20, height: 15)
                Rectangle().id(3).frame(width: 10, height: 25)
            }
            .frame(width: 50, height: 30),
            expectedLayout: """
            1: 23.5 37.5 15.0 20.0
            2: 42.5 37.5 20.0 15.0
            3: 66.5 37.5 10.0 25.0
            """
        )
        
        Utils.assertLeafLayout(
            HStack(alignment: .center, spacing: 4) {
                Rectangle().id(1).frame(width: 15, height: 20)
                Rectangle().id(2).frame(width: 20, height: 15)
                Rectangle().id(3).frame(width: 10, height: 25)
            }
            .frame(width: 50, height: 30),
            expectedLayout: """
            1: 23.5 40.0 15.0 20.0
            2: 42.5 42.5 20.0 15.0
            3: 66.5 37.5 10.0 25.0
            """
        )
        
        Utils.assertLeafLayout(
            HStack(alignment: .bottom, spacing: 4) {
                Rectangle().id(1).frame(width: 15, height: 20)
                Rectangle().id(2).frame(width: 20, height: 15)
                Rectangle().id(3).frame(width: 10, height: 25)
            }
            .frame(width: 50, height: 30),
            expectedLayout: """
            1: 23.5 42.5 15.0 20.0
            2: 42.5 47.5 20.0 15.0
            3: 66.5 37.5 10.0 25.0
            """
        )
    }
    
    func testAlignedCardLayouts() {
        // Test cards with different frame alignments
        Utils.assertLeafLayout(
            AlignedCard(alignment: .topLeft),
            expectedLayout: """
            1: 30.0 35.0 30.0 8.0
            2: 32.5 45.0 25.0 6.0
            3: 35.0 53.0 20.0 4.0
            """
        )
        
        Utils.assertLeafLayout(
            AlignedCard(alignment: .center),
            expectedLayout: """
            1: 35.0 39.0 30.0 8.0
            2: 37.5 49.0 25.0 6.0
            3: 40.0 57.0 20.0 4.0
            """
        )
        
        Utils.assertLeafLayout(
            AlignedCard(alignment: .bottomRight),
            expectedLayout: """
            1: 40.0 43.0 30.0 8.0
            2: 42.5 53.0 25.0 6.0
            3: 45.0 61.0 20.0 4.0
            """
        )
    }
    
    func testAlignedProfileLayouts() {
        // Test profiles with different frame alignments
        Utils.assertLeafLayout(
            AlignedProfile(alignment: .topLeft),
            expectedLayout: """
            4: 27.5 37.5 15.0 15.0
            5: 46.5 40.0 20.0 5.0
            6: 46.5 47.0 15.0 3.0
            """
        )
        
        Utils.assertLeafLayout(
            AlignedProfile(alignment: .center),
            expectedLayout: """
            4: 30.5 42.5 15.0 15.0
            5: 49.5 45.0 20.0 5.0
            6: 49.5 52.0 15.0 3.0
            """
        )
        
        Utils.assertLeafLayout(
            AlignedProfile(alignment: .bottomRight),
            expectedLayout: """
            4: 33.5 47.5 15.0 15.0
            5: 52.5 50.0 20.0 5.0
            6: 52.5 57.0 15.0 3.0
            """
        )
    }
    
    func testMixedAlignmentLayout() {
        // Test complex layout with mixed alignments
        Utils.assertLeafLayout(
            VStack(alignment: .left, spacing: 6) {
                HStack(alignment: .top, spacing: 4) {
                    Rectangle().id(1).frame(width: 12, height: 15)
                    Rectangle().id(2).frame(width: 18, height: 10)
                }
                
                HStack(alignment: .center, spacing: 4) {
                    Rectangle().id(3).frame(width: 15, height: 12)
                    Rectangle().id(4).frame(width: 20, height: 8)
                }
                
                HStack(alignment: .bottom, spacing: 4) {
                    Rectangle().id(5).frame(width: 10, height: 18)
                    Rectangle().id(6).frame(width: 16, height: 14)
                }
            }
            .frame(width: 40, height: 50),
            expectedLayout: """
            1: 30.5 21.5 12.0 15.0
            2: 46.5 21.5 18.0 10.0
            3: 30.5 42.5 15.0 12.0
            4: 49.5 44.5 20.0 8.0
            5: 30.5 60.5 10.0 18.0
            6: 44.5 64.5 16.0 14.0
            """
        )
    }
}
