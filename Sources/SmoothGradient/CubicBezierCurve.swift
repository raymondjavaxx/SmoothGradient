//
//  CubicBezierCurve.swift
//  SmoothGradient
//
//  Copyright (c) 2023 Ramon Torres
//
//  This file is part of SmoothGradient which is released under the MIT license.
//  See the LICENSE file in the root directory of this source tree for full details.
//

import SwiftUI

/// Cubic Bezier curve for interpolating the gradient.
///
/// A Cubic Bezier is defined by four points: p0, p1, ..., p3). For our purpose,
/// p0 and p3 are always fixed  at (0, 0) and (1, 1), respectively.
public struct CubicBezierCurve: Curve {
    let p1: UnitPoint
    let p2: UnitPoint

    let a: CGPoint
    let b: CGPoint
    let c: CGPoint

    public static let easeIn = CubicBezierCurve(
        p1: UnitPoint(x: 0.42, y: 0),
        p2: UnitPoint(x: 1, y: 1)
    )

    public static let easeOut = CubicBezierCurve(
        p1: UnitPoint(x: 0, y: 0),
        p2: UnitPoint(x: 0.58, y: 1)
    )

    public static let easeInOut = CubicBezierCurve(
        p1: UnitPoint(x: 0.42, y: 0),
        p2: UnitPoint(x: 0.58, y: 1)
    )

    public init(p1: UnitPoint, p2: UnitPoint) {
        self.p1 = p1
        self.p2 = p2

        // Calculate coefficients
        self.c = CGPoint(x: 3 * p1.x, y: 3 * p1.y)
        self.b = CGPoint(x: 3 * (p2.x - p1.x) - c.x, y: 3 * (p2.y - p1.y) - c.y)
        self.a = CGPoint(x: 1 - c.x - b.x, y: 1 - c.y - b.y)
    }

    func value(at x: Double) -> Double {
        guard p1 != p2 else { return x }
        return sampleCurveY(getT(x: x))
    }
}

extension CubicBezierCurve {
    private func getT(x: Double) -> Double {
        assert(x >= 0 && x <= 1, "x must be between 0 and 1")

        var guessT = x

        // Newton's method to approximate T
        for _ in 0..<8 {
            let currentSlope = sampleCurveDerivativeX(guessT)
            if currentSlope == 0 {
                return guessT
            }

            let currentX = sampleCurveX(guessT) - x
            guessT -= currentX / currentSlope
        }

        return guessT
    }

    private func sampleCurveX(_ t: Double) -> Double {
        return ((a.x * t + b.x) * t + c.x) * t
    }

    private func sampleCurveY(_ t: Double) -> Double {
        return ((a.y * t + b.y) * t + c.y) * t
    }

    private func sampleCurveDerivativeX(_ t: Double) -> Double {
        return (3 * a.x * t + 2 * b.x) * t + c.x
    }
}

// MARK: - Preview

@available(iOS 13.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
struct CubicBezierCurve_Previews: PreviewProvider {
    static var previews: some View {
        Canvas(opaque: true) { context, size in
            context.withCGContext { ctx in
                func plot(
                    color: CGColor,
                    dashed: Bool = false,
                    function: (Double) -> Double
                ) {
                    let steps = 16

                    ctx.beginPath()
                    ctx.move(to: CGPoint(x: 0, y: size.height))
                    for step in stride(from: 0, to: steps, by: 1) {
                        let x = Double(step) / Double(steps - 1)
                        let y = 1 - function(x)
                        ctx.addLine(to: CGPoint(x: x * size.width, y: y * size.height))
                    }

                    ctx.setLineWidth(3)
                    ctx.setStrokeColor(color)
                    if dashed {
                        ctx.setLineDash(
                            phase: 0,
                            lengths: [size.width / CGFloat(steps * 2)]
                        )
                    }

                    ctx.strokePath()
                }

                ctx.beginPath()
                ctx.addRect(CGRect(origin: .zero, size: size))
                ctx.setFillColor(CGColor(gray: 1, alpha: 1))
                ctx.fillPath()

                plot(
                    color: CGColor(red: 1, green: 0, blue: 0, alpha: 1)
                ) { progress in
                    CubicBezierCurve.easeInOut.value(at: progress)
                }

                plot(
                    color: CGColor(red: 0, green: 1, blue: 0, alpha: 1),
                    dashed: true
                ) { progress in
                    CubicBezierCurve.easeInOut.value(at: progress)
                }
            }
        }
        .frame(width: 400, height: 400)
    }
}
