//
//  RuneDemo.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 23.05.2026.
//

import RuneUI

@main
final class RuneDemo {
    static func main() {
        RuneDemo().main()
    }
    
    func main() {
        LayoutConfiguration.defaultHStackSpacing = 1
        LayoutConfiguration.defaultVStackSpacing = 0
        
        let rune = Rune(width: 100, height: 15)
        rune.draw(self.body)
    }
    
    private let longText = "This is very very very very long text! This is very very very very long text! This is very very very very long text! This is very very very very long text! This is very very very very long text! This is very very very very long text!"
    
    private var body: LayoutItem {
        VStack {
            Text("Rune demo!")
            
            HStack(alignment: .top) {
                Box()
                    .frame(width: 10)
                
                Text("Hello\nworld!")
                    .padding(1)
                    .background(Box())
                
                Text(self.longText)
                    .padding(1)
                    .background(Box())
            }
        }
        .padding(2)
        .background(Box())
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}
