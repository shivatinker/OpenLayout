//
//  SortedByKey.swift
//
//
//  Created by Andrii Zinoviev on 13.06.2024.
//

extension Collection {
    func sorted(key: (Element) -> some Comparable, isAscendingOrder: Bool = true) -> [Element] {
        self.sorted {
            if isAscendingOrder {
                key($0) < key($1)
            }
            else {
                key($0) > key($1)
            }
        }
    }
}

extension EnumeratedSequence {
    func sorted(key: (Element) -> some Comparable, isAscendingOrder: Bool = true) -> [Element] {
        self.sorted {
            if isAscendingOrder {
                key($0) < key($1)
            }
            else {
                key($0) > key($1)
            }
        }
    }
}
