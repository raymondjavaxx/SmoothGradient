//
//  Gradient+Smooth.swift
//  SmoothGradient
//
//  Copyright (c) 2023 Ramon Torres
//
//  This file is part of SmoothGradient which is released under the MIT license.
//  See the LICENSE file in the root directory of this source tree for full details.
//

import SwiftUI

// MARK: - iOS 17

extension Gradient {
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public static func smooth(
        from: Color,
        to: Color,
        curve: UnitCurve = .easeInOut,
        steps: Int = 16
    ) -> Gradient {
        return makeSmoothGradient(
            from: Stop(color: from, location: 0),
            to: Stop(color: to, location: 1),
            curve: curve,
            steps: steps
        )
    }

    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    public static func smooth(
        from: Stop,
        to: Stop,
        curve: UnitCurve = .easeInOut,
        steps: Int = 16
    ) -> Gradient {
        return makeSmoothGradient(
            from: from,
            to: to,
            curve: curve,
            steps: steps
        )
    }
}

// MARK: - Pre iOS 17

extension Gradient {
    @available(iOS, introduced: 13.0, deprecated: 17.0, renamed: "smooth(from:to:curve:steps:)")
    @available(macOS, introduced: 10.15, deprecated: 14.0, renamed: "smooth(from:to:curve:steps:)")
    @available(tvOS, introduced: 13.0, deprecated: 17.0, renamed: "smooth(from:to:curve:steps:)")
    @available(watchOS, introduced: 6.0, deprecated: 10.0, renamed: "smooth(from:to:curve:steps:)")
    @_disfavoredOverload
    public static func smooth(
        from: Color,
        to: Color,
        easing curve: CubicBezierCurve = .easeInOut,
        steps: Int = 16
    ) -> Gradient {
        return smooth(
            from: Stop(color: from, location: 0),
            to: Stop(color: to, location: 1),
            easing: curve,
            steps: steps
        )
    }

    @available(iOS, introduced: 13.0, deprecated: 17.0, renamed: "smooth(from:to:curve:steps:)")
    @available(macOS, introduced: 10.15, deprecated: 14.0, renamed: "smooth(from:to:curve:steps:)")
    @available(tvOS, introduced: 13.0, deprecated: 17.0, renamed: "smooth(from:to:curve:steps:)")
    @available(watchOS, introduced: 6.0, deprecated: 10.0, renamed: "smooth(from:to:curve:steps:)")
    @_disfavoredOverload
    public static func smooth(
        from: Stop,
        to: Stop,
        easing curve: CubicBezierCurve = .easeInOut,
        steps: Int = 16
    ) -> Gradient {
        return makeSmoothGradient(
            from: from,
            to: to,
            curve: curve,
            steps: steps
        )
    }
}

// MARK: - Factory

extension Gradient {
    private static func makeSmoothGradient(
        from: Stop,
        to: Stop,
        curve: Curve,
        steps: Int
    ) -> Gradient {
        let ramp = stride(from: 0, to: steps, by: 1).lazy.map { index in
            Double(index) / Double(steps - 1)
        }

        let interpolator = GradientInterpolator(
            curve: curve,
            color1: from.color,
            color2: to.color
        )

        return Gradient(stops: ramp.map { progress in
            Stop(
                color: interpolator.blend(progress: progress),
                location: from.location + progress * (to.location - from.location)
            )
        })
    }
}

// MARK: - Preview

struct Gradient_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
                LinearGradient(
                    gradient: .smooth(
                        from: .black,
                        to: .black.opacity(0),
                        curve: .easeInOut
                    ),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 200)
            } else {
                LinearGradient(
                    gradient: .smooth(
                        from: .black,
                        to: .black.opacity(0),
                        easing: .easeInOut
                    ),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 200)
            }
            Spacer()
        }
        .background(Color.white, alignment: .center)
    }
}
