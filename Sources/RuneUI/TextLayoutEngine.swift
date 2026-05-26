//
//  TextLayoutEngine.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 23.05.2026.
//

struct ComputedTextLayout {
    let frame: Rect
    let lines: [String]
}

enum TextLayoutEngine {
    static func layoutText(x minX: Int, y minY: Int, text: String, maxWidth: Int?) -> ComputedTextLayout {
        var lines: [String] = []
        var line = ""
        
        var x = minX
        var y = minY
        
        func flushLine() {
            lines.append(line)
            line = ""
            x = minX
            y += 1
        }
        
        for character in text {
            if character == "\n" {
                flushLine()
                continue
            }
            
            if let maxWidth, x - minX >= maxWidth {
                flushLine()
            }
            
            x += 1
            line.append(String(character))
        }
        
        if false == line.isEmpty {
            flushLine()
        }
        
        let width = lines.map(\.count).max() ?? 0
        let height = lines.count
        
        return ComputedTextLayout(
            frame: Rect(x: minX, y: minY, width: width, height: height),
            lines: lines
        )
    }
}
