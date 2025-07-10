//
//  CustomLayoutItemTests.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 10.07.2025.
//

import OpenLayout
import XCTest

// MARK: - Custom Composite Layout Items

struct Card: LayoutItem {
    let title: String
    let backgroundColor: String
    
    var body: some LayoutItem {
        VStack(spacing: 8) {
            Rectangle(1).frame(width: 100, height: 20)
            Rectangle(2).frame(width: 80, height: 15)
            Rectangle(3).frame(width: 60, height: 10)
        }
        .padding(10)
        .frame(minWidth: 120, maxWidth: 150, minHeight: 80, maxHeight: 120)
    }
}

struct ProfileCard: LayoutItem {
    let name: String
    let avatarSize: CGFloat
    
    var body: some LayoutItem {
        HStack(spacing: 12) {
            Rectangle(4).frame(width: self.avatarSize, height: self.avatarSize)
            
            VStack(spacing: 4) {
                Rectangle(5).frame(width: 60, height: 12)
                Rectangle(6).frame(width: 40, height: 8)
            }
        }
        .padding(8)
        .frame(minWidth: 100, maxWidth: 200)
    }
}

struct Dashboard: LayoutItem {
    let showHeader: Bool
    
    var body: some LayoutItem {
        VStack(spacing: 16) {
            if self.showHeader {
                Rectangle(7).frame(width: 200, height: 30)
            }
            
            HStack(spacing: 20) {
                Card(title: "Stats", backgroundColor: "blue")
                ProfileCard(name: "John", avatarSize: 40)
            }
            
            Rectangle(8).frame(width: 180, height: 25)
        }
        .padding(16)
    }
}

struct ResponsiveGrid: LayoutItem {
    let columns: Int
    let spacing: CGFloat
    
    var body: some LayoutItem {
        VStack(spacing: self.spacing) {
            for row in 0..<self.columns {
                HStack(spacing: self.spacing) {
                    for col in 0..<self.columns {
                        Rectangle(row * self.columns + col + 9)
                            .frame(width: 20, height: 20)
                    }
                }
            }
        }
        .padding(10)
    }
}

// MARK: - Tests

@MainActor
final class CustomLayoutItemTests: XCTestCase {
    func testSimpleCardLayout() {
        Utils.assertLeafLayout(
            Card(title: "Test Card", backgroundColor: "red"),
            expectedLayout: """
            1: 19.5 0.0 100.0 20.0
            2: 19.5 108.0 80.0 15.0
            3: 19.5 196.0 60.0 10.0
            """
        )
    }
    
    func testProfileCardLayout() {
        Utils.assertLeafLayout(
            ProfileCard(name: "Alice", avatarSize: 50),
            expectedLayout: """
            4: -11.0 25.0 50.0 50.0
            5: 25.0 51.0 60.0 12.0
            6: 25.0 119.0 40.0 8.0
            """
        )
    }
    
    func testComplexDashboardLayout() {
        Utils.assertLeafLayout(
            Dashboard(showHeader: true),
            expectedLayout: """
            1: 134.0 -16.0 100.0 20.0
            2: 134.0 92.0 80.0 15.0
            3: 134.0 180.0 60.0 10.0
            4: 122.0 132.0 40.0 40.0
            5: 132.0 174.0 60.0 12.0
            6: 132.0 242.0 40.0 8.0
            7: -26.0 -84.0 200.0 30.0
            8: -26.0 400.0 180.0 25.0
            """
        )
    }
    
    func testResponsiveGridLayout() {
        Utils.assertLeafLayout(
            ResponsiveGrid(columns: 2, spacing: 5),
            expectedLayout: """
            9: 26.0 27.5 20.0 20.0
            10: 51.0 27.5 20.0 20.0
            11: 26.0 80.5 20.0 20.0
            12: 51.0 80.5 20.0 20.0
            """
        )
    }
    
    func testNestedCustomLayoutItems() {
        Utils.assertLeafLayout(
            VStack(spacing: 20) {
                Card(title: "First", backgroundColor: "green")
                HStack(spacing: 15) {
                    ProfileCard(name: "Bob", avatarSize: 35)
                    Card(title: "Second", backgroundColor: "purple")
                }
                ResponsiveGrid(columns: 2, spacing: 5)
            },
            expectedLayout: """
            1: 59.0 75.0 100.0 20.0
            2: 59.0 183.0 80.0 15.0
            3: 59.0 271.0 60.0 10.0
            4: -65.0 57.0 35.0 35.0
            5: 57.0 -18.0 60.0 12.0
            6: 57.0 50.0 40.0 8.0
            9: 325.0 -63.0 20.0 20.0
            10: 350.0 -63.0 20.0 20.0
            11: 325.0 -10.0 20.0 20.0
            12: 350.0 -10.0 20.0 20.00
            """
        )
    }
}
