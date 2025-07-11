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
                Rectangle().id(1).frame(minWidth: 60, maxWidth: 80)
                Rectangle().id(2).frame(width: 20, height: 20)
            },
            expectedLayout: """
            1: 0.0 0.0 70.0 100.0
            2: 80.0 40.0 20.0 20.0
            """
        )
    }
    
    func testComplexNestedStacks() {
        Utils.assertLeafLayout(
            HStack(spacing: 10) {
                VStack(spacing: 5) {
                    Rectangle().id(1).frame(width: 10, height: 15)
                    Rectangle().id(2).frame(width: 15, height: 20)
                }
                .padding(10)
                
                Rectangle().id(3).frame(minWidth: 10, maxWidth: 50)
                
                VStack(spacing: 3) {
                    Rectangle().id(4).padding(5)
                    Rectangle().id(5).frame(width: 15, height: 12)
                }
                .frame(minHeight: 40, maxHeight: 60)
            },
            expectedLayout: """
            1: 12.5 30.0 10.0 15.0
            2: 10.0 50.0 15.0 20.0
            3: 45.0 0.0 22.5 100.0
            4: 82.5 25.0 12.5 35.0
            5: 81.2 68.0 15.0 12.0
            """
        )
    }
    
    func testComplexMixedLayouts() {
        Utils.assertLeafLayout(
            VStack(spacing: 12) {
                HStack(spacing: 6) {
                    Rectangle().id(1).frame(width: 30, height: 25)
                    Rectangle().id(2).frame(minWidth: 20, maxWidth: 35)
                    Rectangle().id(3).padding(4)
                }
                .frame(minHeight: 30, maxHeight: 40)
                
                Rectangle().id(4).frame(width: 80, height: 20)
                
                HStack(spacing: 8) {
                    Rectangle().id(5).frame(width: 15, height: 15)
                    Rectangle().id(6).frame(minWidth: 25, maxWidth: 40, minHeight: 10, maxHeight: 25)
                    Rectangle().id(7).padding(3)
                }
                .padding(5)
            },
            expectedLayout: """
            1: 0.0 2.5 30.0 25.0
            2: 36.0 0.0 29.0 30.0
            3: 75.0 4.0 21.0 22.0
            4: 10.0 42.0 80.0 20.0
            5: 5.0 79.5 15.0 15.0
            6: 28.0 79.0 29.5 16.0
            7: 68.5 82.0 23.5 10.0
            """
        )
    }
    
    func testComplexFlexibleLayout() {
        Utils.assertLeafLayout(
            HStack(spacing: 5) {
                VStack(spacing: 8) {
                    Rectangle().id(1).frame(minWidth: 25, maxWidth: 45, minHeight: 20, maxHeight: 35)
                    Rectangle().id(2).frame(width: 30, height: 25)
                }
                .padding(5)
                .frame(minWidth: 40, maxWidth: 70)
                
                Rectangle().id(3).frame(minWidth: 20, maxWidth: 40, minHeight: 30, maxHeight: 50)
                
                VStack(spacing: 5) {
                    Rectangle().id(4).padding(6)
                    Rectangle().id(5).frame(width: 22, height: 18)
                    Rectangle().id(6).frame(minWidth: 15, maxWidth: 30, minHeight: 12, maxHeight: 22)
                }
                .frame(minHeight: 60, maxHeight: 80)
            },
            expectedLayout: """
            1: 4.0 16.0 30.0 35.0
            2: 4.0 59.0 30.0 25.0
            3: 44.0 25.0 30.7 50.0
            4: 85.7 16.0 10.0 18.0
            5: 79.7 45.0 22.0 18.0
            6: 79.7 68.0 22.0 22.0
            """
        )
    }
}
