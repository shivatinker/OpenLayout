//
//  Drawable.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 23.05.2026.
//

struct Rect {
    let x: Int
    let y: Int
    let width: Int
    let height: Int
}

struct CharacterAttributes {
    let foregroundColor: Color
    
    static let `default` = CharacterAttributes(
        foregroundColor: .white
    )
}

protocol DrawContext {
    func setCharacter(x: Int, y: Int, _ character: Character, attributes: CharacterAttributes)
}

protocol Drawable {
    func draw(context: DrawContext, frame: Rect)
}

enum Color {
    case white
}

struct TextDrawable: Drawable {
    let text: String
    let attributes: CharacterAttributes
    
    func draw(context: any DrawContext, frame: Rect) {
        let layout = TextLayoutEngine.layoutText(x: frame.x, y: frame.y, text: self.text, maxWidth: frame.width)
        
        var x = frame.x
        var y = frame.y
        
        for line in layout.lines {
            for character in line {
                context.setCharacter(x: x, y: y, character, attributes: self.attributes)
                x += 1
            }
            
            y += 1
            x = frame.x
        }
    }
}

struct BoxDrawable: Drawable {
    let attributes: CharacterAttributes
    
    func draw(context: any DrawContext, frame: Rect) {
        guard frame.width > 0, frame.height > 0 else { return }

        let x = frame.x
        let y = frame.y
        let w = frame.width
        let h = frame.height

        context.setCharacter(x: x, y: y, "┌", attributes: self.attributes)
        context.setCharacter(x: x + w - 1, y: y, "┐", attributes: self.attributes)
        context.setCharacter(x: x, y: y + h - 1, "└", attributes: self.attributes)
        context.setCharacter(x: x + w - 1, y: y + h - 1, "┘", attributes: self.attributes)

        for col in (x + 1)..<(x + w - 1) {
            context.setCharacter(x: col, y: y, "─", attributes: self.attributes)
            context.setCharacter(x: col, y: y + h - 1, "─", attributes: self.attributes)
        }

        for row in (y + 1)..<(y + h - 1) {
            context.setCharacter(x: x, y: row, "│", attributes: self.attributes)
            context.setCharacter(x: x + w - 1, y: row, "│", attributes: self.attributes)
        }
    }
}
