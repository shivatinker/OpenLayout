//
//  ImageDiffer.swift
//  OpenLayout
//
//  Adapted from https://github.com/pointfreeco/swift-snapshot-testing/blob/main/Sources/SnapshotTesting/Snapshotting/NSImage.swift
//

import AppKit
import CoreImage

enum ImageDiffer {
    struct Mismatch {
        let message: String
        let reference: NSImage
        let actual: NSImage
        let difference: NSImage
    }

    static func compare(
        _ reference: NSImage,
        _ actual: NSImage,
        precision: Float = 1
    ) -> Mismatch? {
        guard let message = compareImages(reference, actual, precision: precision) else {
            return nil
        }
        return Mismatch(
            message: message,
            reference: reference,
            actual: actual,
            difference: diffImage(reference, actual)
        )
    }
}

private func compareImages(_ old: NSImage, _ new: NSImage, precision: Float) -> String? {
    guard let oldCG = old.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
        return "Reference image could not be loaded."
    }
    guard let newCG = new.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
        return "Actual image could not be loaded."
    }
    guard newCG.width != 0, newCG.height != 0 else {
        return "Actual image is empty."
    }
    guard oldCG.width == newCG.width, oldCG.height == newCG.height else {
        return "Image size mismatch: reference \(old.size) vs actual \(new.size)."
    }
    guard let oldCtx = context(for: oldCG), let oldData = oldCtx.data else {
        return "Reference image data could not be loaded."
    }
    guard let newCtx = context(for: newCG), let newData = newCtx.data else {
        return "Actual image data could not be loaded."
    }
    let byteCount = oldCtx.height * oldCtx.bytesPerRow
    if memcmp(oldData, newData, byteCount) == 0 { return nil }
    guard precision < 1 else {
        return "Images do not match pixel-for-pixel."
    }
    let threshold = Int((1 - precision) * Float(byteCount))
    let oldBytes = oldData.bindMemory(to: UInt8.self, capacity: byteCount)
    let newBytes = newData.bindMemory(to: UInt8.self, capacity: byteCount)
    var diff = 0
    // NB: while loop is significantly faster than for-in in unoptimized test builds.
    // https://github.com/apple/swift/issues/49531
    var i = 0
    while i < byteCount {
        defer { i += 1 }
        if oldBytes[i] != newBytes[i] { diff += 1 }
    }
    let actual = 1 - Float(diff) / Float(byteCount)
    print("Precision: \(actual)")
    if diff > threshold {
        return "Actual precision \(actual) is less than required \(precision)."
    }
    return nil
}

private func context(for cgImage: CGImage) -> CGContext? {
    guard
        let space = cgImage.colorSpace,
        let ctx = CGContext(
            data: nil,
            width: cgImage.width,
            height: cgImage.height,
            bitsPerComponent: cgImage.bitsPerComponent,
            bytesPerRow: cgImage.bytesPerRow,
            space: space,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        )
    else { return nil }
    ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: cgImage.width, height: cgImage.height))
    return ctx
}

private func diffImage(_ old: NSImage, _ new: NSImage) -> NSImage {
    let oldCI = CIImage(cgImage: old.cgImage(forProposedRect: nil, context: nil, hints: nil)!)
    let newCI = CIImage(cgImage: new.cgImage(forProposedRect: nil, context: nil, hints: nil)!)
    let filter = CIFilter(name: "CIDifferenceBlendMode")!
    filter.setValue(oldCI, forKey: kCIInputImageKey)
    filter.setValue(newCI, forKey: kCIInputBackgroundImageKey)
    let size = CGSize(
        width: max(old.size.width, new.size.width),
        height: max(old.size.height, new.size.height)
    )
    let result = NSImage(size: size)
    result.addRepresentation(NSCIImageRep(ciImage: filter.outputImage!))
    return result
}
