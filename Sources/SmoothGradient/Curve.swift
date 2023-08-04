//
//  Curve.swift
//  SmoothGradient
//
//  Copyright (c) 2023 Ramon Torres
//
//  This file is part of SmoothGradient which is released under the MIT license.
//  See the LICENSE file in the root directory of this source tree for full details.
//

import SwiftUI

protocol Curve {
    func value(at progress: Double) -> Double
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension UnitCurve: Curve {}
