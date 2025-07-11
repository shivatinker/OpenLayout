//
//  TextLayoutEngine.swift
//  OpenLayout
//
//  Created by Andrii Zinoviev on 11.07.2025.
//

import OpenLayout

public protocol TextLayoutEngine {
    func sizeThatFits(
        _ proposal: ProposedSize,
        text: String,
        attributes: TextAttributes
    ) -> CGSize
}
