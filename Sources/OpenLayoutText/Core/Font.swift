import Foundation
import CoreGraphics

public struct Font: Sendable, Equatable {
    public let name: String
    public let size: CGFloat

    public init(name: String, size: CGFloat) {
        self.name = name
        self.size = size
    }

    public static let `default` = Font(name: "Helvetica", size: 12)
} 