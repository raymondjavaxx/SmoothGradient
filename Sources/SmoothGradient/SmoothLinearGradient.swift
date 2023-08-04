//
//  SmoothLinearGradient.swift
//  SmoothGradientTests
//
//  Copyright (c) 2023 Ramon Torres
//
//  This file is part of SmoothGradient which is released under the MIT license.
//  See the LICENSE file in the root directory of this source tree for full details.
//

import SwiftUI

#if compiler(>=5.9)
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct SmoothLinearGradient: ShapeStyle, View {
    let from: Gradient.Stop
    let to: Gradient.Stop
    let startPoint: UnitPoint
    let endPoint: UnitPoint
    let curve: UnitCurve
    let steps: Int

    public init(
        from: Color,
        to: Color,
        startPoint: UnitPoint,
        endPoint: UnitPoint,
        curve: UnitCurve = .easeInOut,
        steps: Int = 16
    ) {
        self.init(
            from: Gradient.Stop(color: from, location: 0),
            to: Gradient.Stop(color: to, location: 1),
            startPoint: startPoint,
            endPoint: endPoint,
            curve: curve,
            steps: steps
        )
    }

    public init(
        from: Gradient.Stop,
        to: Gradient.Stop,
        startPoint: UnitPoint,
        endPoint: UnitPoint,
        curve: UnitCurve = .easeInOut,
        steps: Int = 16
    ) {
        self.from = from
        self.to = to
        self.startPoint = startPoint
        self.endPoint = endPoint
        self.curve = curve
        self.steps = steps
    }

    public func resolve(in environment: EnvironmentValues) -> LinearGradient {
        LinearGradient(
            gradient: .smooth(from: from, to: to, curve: curve, steps: steps),
            startPoint: startPoint,
            endPoint: endPoint
        )
    }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
struct SmoothLinearGradient_Previews: PreviewProvider {
    static var previews: some View {
        SmoothLinearGradient(
            from: .green,
            to: .blue,
            startPoint: .leading,
            endPoint: .trailing,
            curve: .easeInOut
        )
        .ignoresSafeArea()
        .previewDisplayName("Colors")

        SmoothLinearGradient(
            from: .init(color: .black, location: 0),
            to: .init(color: .black.opacity(0), location: 0.75),
            startPoint: .top,
            endPoint: .bottom,
            curve: .easeInOut
        )
        .ignoresSafeArea()
        .previewDisplayName("Stops")
    }
}
#endif
