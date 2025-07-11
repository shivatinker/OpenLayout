//
//  LayoutTests.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 10.07.2025.
//

import OpenLayout
import XCTest

struct IDNodeAttributeKey: NodeAttributeKey {
    typealias Value = Int?
    
    static let defaultValue: Int? = nil
}

extension LayoutItem {
    func id(_ value: Int) -> some LayoutItem {
        self.attribute(IDNodeAttributeKey.self, value)
    }
}

struct Rectangle: LayoutLeafItem {
    struct Layout: LeafLayout {
        func sizeThatFits(_ size: ProposedSize) -> CGSize {
            size.replacingUnspecifiedDimensions(
                by: CGSize(width: 10, height: 10)
            )
        }
    }
    
    let layout = Layout()
}

@MainActor
final class LayoutTests: XCTestCase {
    func testSimple() {
        Utils.assertLeafLayout(
            Rectangle().id(1),
            expectedLayout: """
            1: 0.0 0.0 100.0 100.0
            """
        )
    }
}

enum Utils {
    static let defaultRect = CGRect(
        origin: .zero,
        size: CGSize(width: 100, height: 100)
    )
    
    @MainActor
    static func assertLeafLayout(
        _ root: some LayoutItem,
        rect: CGRect = Utils.defaultRect,
        expectedLayout: String,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let actualDict = self.getActualLayoutDict(root: root, rect: rect)
        let actualString = self.layoutDictToString(actualDict)
        let expectedString = self.normalizeLayoutString(expectedLayout)
        
        if actualString != expectedString {
            // Generate visualization image
            self.visualize(root)
            
            XCTFail("""
            Layout mismatch!
            Expected:
            \(expectedString)
            Actual:
            \(actualString)
            """, file: file, line: line)
        }
        else {
            XCTAssertEqual(actualString, expectedString, file: file, line: line)
        }
    }
    
    @MainActor
    private static func visualize(_ root: some LayoutItem) {
        let image = LayoutVisualizer.visualize(root)
        if let pngData = cgImageToPNGData(image) {
            let attachment = XCTAttachment(data: pngData, uniformTypeIdentifier: "public.png")
            attachment.name = "Layout Visualization"
            attachment.lifetime = .keepAlways
            XCTContext.runActivity(named: "Attach layout visualization") { activity in
                activity.add(attachment)
            }
        }
    }

    private static func getActualLayoutDict(
        root: some LayoutItem,
        rect: CGRect
    ) -> [Int: CGRect] {
        let engine = LayoutEngine()
        
        var layout: [Int: CGRect] = [:]
        
        engine.layout(
            in: rect,
            root: root.makeNode()
        ) { item in
            guard item.node.leafItem != nil else {
                return
            }
            
            guard let id = item.attributes.value(for: IDNodeAttributeKey.self) else {
                return
            }
            
            layout[id] = item.rect
        }
        
        return layout
    }

    private static func layoutDictToString(_ dict: [Int: CGRect]) -> String {
        dict.keys.sorted().map { id in
            let r = dict[id]!
            return String(format: "%d: %.1f %.1f %.1f %.1f", id, r.origin.x, r.origin.y, r.size.width, r.size.height)
        }.joined(separator: "\n")
    }

    private static func normalizeLayoutString(_ string: String) -> String {
        string
            .split(separator: "\n")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
            .joined(separator: "\n")
    }

    // Helper to convert CGImage to PNG Data
    private static func cgImageToPNGData(_ image: CGImage) -> Data? {
        let data = NSMutableData()
        guard let destination = CGImageDestinationCreateWithData(data, "public.png" as CFString, 1, nil) else { return nil }
        CGImageDestinationAddImage(destination, image, nil)
        guard CGImageDestinationFinalize(destination) else { return nil }
        return data as Data
    }
}
