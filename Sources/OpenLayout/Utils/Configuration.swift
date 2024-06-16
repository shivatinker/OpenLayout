//
//  Configuration.swift
//
//
//  Created by Andrii Zinoviev on 16.06.2024.
//

struct Configuration {
    static var current = Configuration(
        warningHandler: DefaultLayoutWarningHandler()
    )
    
    var warningHandler: LayoutWarningHandler
    
    static func withCustomWarningHandler<T>(
        _ handleWarning: (LayoutWarning) -> Void,
        _ execute: () -> T
    ) -> T {
        withoutActuallyEscaping(handleWarning) { escapingHandler in
            let oldHandler = Self.current.warningHandler
        
            Self.current.warningHandler = BlockWarningHandler(handler: escapingHandler)
            
            let result = execute()
        
            Self.current.warningHandler = oldHandler
        
            return result
        }
    }
}

struct BlockWarningHandler: LayoutWarningHandler {
    let handler: (LayoutWarning) -> Void
    
    func handle(_ warning: LayoutWarning) {
        self.handler(warning)
    }
}
