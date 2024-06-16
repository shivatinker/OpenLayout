//
//  NodeInfoTests.swift
//
//
//  Created by Andrii Zinoviev on 16.06.2024.
//

@testable import OpenLayout
import XCTest

final class NodeInfoTests: XCTestCase {
    func testNodeInfo() {
        var info = NodeInfo()
        
        info.tags.insert(1)
        info.tags.insert(2)
        
        XCTAssertEqual(info.tags, [1, 2])
    }
}
