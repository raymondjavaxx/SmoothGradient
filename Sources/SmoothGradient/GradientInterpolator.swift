//
//  GradientInterpolator.swift
//  SmoothGradient
//
//  Copyright (c) 2023 Ramon Torres
//
//  This file is part of SmoothGradient which is released under the MIT license.
//  See the LICENSE file in the root directory of this source tree for full details.
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#else
import AppKit
#endif

struct GradientInterpolator {
    #if canImport(UIKit)
    /// Alias of UIColor.
    private typealias PlatformColor = UIColor
    #else
    /// Alias of NSColor.
    private typealias PlatformColor = NSColor
    #endif

    private let curve: Curve
    private let color1: PlatformColor
    private let color2: PlatformColor

    init(curve: Curve, color1: Color, color2: Color) {
        self.curve = curve
        self.color1 = PlatformColor(color1)
        self.color2 = PlatformColor(color2)
    }

    func blend(progress: Double) -> Color {
        // Use a dynamic color to ensure that the gradient is updated when the
        // system appearance changes.
        return Color(Self.makeDynamicColor {
            var r1: CGFloat = 0
            var g1: CGFloat = 0
            var b1: CGFloat = 0
            var a1: CGFloat = 0

            var r2: CGFloat = 0
            var g2: CGFloat = 0
            var b2: CGFloat = 0
            var a2: CGFloat = 0

            Self.getRed(&r1, green: &g1, blue: &b1, alpha: &a1, from: color1)
            Self.getRed(&r2, green: &g2, blue: &b2, alpha: &a2, from: color2)

            let value = curve.value(at: progress)

            let r = r1 + (r2 - r1) * value
            let g = g1 + (g2 - g1) * value
            let b = b1 + (b2 - b1) * value
            let a = a1 + (a2 - a1) * value

            return .init(red: r, green: g, blue: b, alpha: a)
        })
    }
}

extension GradientInterpolator {
    private static func makeDynamicColor(_ block: @escaping () -> PlatformColor) -> PlatformColor {
        #if canImport(UIKit)
        #if os(watchOS)
        // watchOS doesn't support dynamic color providers. We simply invoke
        // the block and return the transformed color.
        return block()
        #else
        // iOS, iPadOS, Mac Catalyst, and tvOS
        return PlatformColor { _ in block() }
        #endif
        #else
        // macOS
        return PlatformColor(name: nil) { _ in block() }
        #endif
    }

    private static func getRed(
        _ red: inout CGFloat,
        green: inout CGFloat,
        blue: inout CGFloat,
        alpha: inout CGFloat,
        from color: PlatformColor
    ) {
        #if canImport(UIKit)
        let result = color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        assert(result, "Failed to get RGBA components from UIColor")
        #else
        if let rgbColor = color.usingColorSpace(.sRGB) {
            rgbColor.getRed(
                &red,
                green: &green,
                blue: &blue,
                alpha: &alpha
            )
        } else {
            assertionFailure("Failed to convert color space")
        }
        #endif
    }
}
