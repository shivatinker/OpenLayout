//
//  ComplexTests.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 10.07.2025.
//

import OpenLayout
import XCTest

@MainActor
final class ComplexTests: XCTestCase {
    func testSimpleMinWidthConstraint() {
        Utils.assertLeafLayout(
            HStack(spacing: 10) {
                Rectangle(1).frame(minWidth: 60, maxWidth: 80)
                Rectangle(2).frame(width: 20, height: 20)
            },
            expectedLayout: """
            1: 0.0 0.0 70.0 100.0
            2: 80.0 0.0 20.0 20.0
            """
        )
    }
    
    func testComplexNestedStacks() {
        Utils.assertLeafLayout(
            HStack(spacing: 10) {
                VStack(spacing: 5) {
                    Rectangle(1).frame(width: 20, height: 15)
                    Rectangle(2).frame(width: 25, height: 20)
                }
                .padding(8)
                
                Rectangle(3).frame(minWidth: 30, maxWidth: 50)
                
                VStack(spacing: 3) {
                    Rectangle(4).padding(2)
                    Rectangle(5).frame(width: 18, height: 12)
                }
                .frame(minHeight: 40, maxHeight: 60)
            },
            expectedLayout: """
            1: 8.0 8.0 20.0 15.0
            2: 8.0 28.0 25.0 20.0
            3: 51.0 0.0 31.0 100.0
            4: 92.0 8.0 14.0 14.0
            5: 92.0 25.0 18.0 12.0
            """
        )
    }
    
    func testComplexMixedLayouts() {
        Utils.assertLeafLayout(
            VStack(spacing: 12) {
                HStack(spacing: 6) {
                    Rectangle(1).frame(width: 30, height: 25)
                    Rectangle(2).frame(minWidth: 20, maxWidth: 35)
                    Rectangle(3).padding(4)
                }
                .frame(minHeight: 30, maxHeight: 40)
                
                Rectangle(4).frame(width: 80, height: 20)
                
                HStack(spacing: 8) {
                    Rectangle(5).frame(width: 15, height: 15)
                    Rectangle(6).frame(minWidth: 25, maxWidth: 40, minHeight: 10, maxHeight: 25)
                    Rectangle(7).padding(3)
                }
                .padding(5)
            },
            expectedLayout: """
            1: 0.0 0.0 30.0 25.0
            2: 36.0 0.0 29.0 30.0
            3: 75.0 4.0 21.0 22.0
            4: 0.0 78.0 80.0 20.0
            5: 5.0 171.0 15.0 15.0
            6: 28.0 171.0 29.5 15.0
            7: 68.5 174.0 23.5 9.0
            """
        )
    }
    
    func testComplexFlexibleLayout() {
        Utils.assertLeafLayout(
            HStack(spacing: 15) {
                VStack(spacing: 8) {
                    Rectangle(1).frame(minWidth: 25, maxWidth: 45, minHeight: 20, maxHeight: 35)
                    Rectangle(2).frame(width: 30, height: 25)
                }
                .padding(10)
                .frame(minWidth: 50, maxWidth: 70)
                
                Rectangle(3).frame(minWidth: 20, maxWidth: 40, minHeight: 30, maxHeight: 50)
                
                VStack(spacing: 5) {
                    Rectangle(4).padding(6)
                    Rectangle(5).frame(width: 22, height: 18)
                    Rectangle(6).frame(minWidth: 15, maxWidth: 30, minHeight: 12, maxHeight: 22)
                }
                .frame(minHeight: 60, maxHeight: 80)
            },
            expectedLayout: """
            1: 16.0 -1.0 45.0 20.0
            2: 16.0 32.0 30.0 25.0
            3: 54.0 6.0 21.0 50.0
            4: 12.0 96.0 68.0 0.0
            5: 6.0 110.0 22.0 18.0
            6: 6.0 140.0 30.0 12.0
            """
        )
    }
}
