//
//  SmoothLinearGradientTests.swift
//  SmoothGradientTests
//
//  Copyright (c) 2023 Ramon Torres
//
//  This file is part of SmoothGradient which is released under the MIT license.
//  See the LICENSE file in the root directory of this source tree for full details.
//

import XCTest
import SwiftUI
import SnapshotTesting
import SmoothGradient

#if compiler(>=5.9)
#if os(iOS)
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
final class SmoothLinearGradientTests: XCTestCase {
    func test_horizontal() {
        verify(
            SmoothLinearGradient(from: .green, to: .blue, startPoint: .leading, endPoint: .trailing)
        )
    }

    func test_vertical() {
        verify(
            SmoothLinearGradient(from: .green, to: .blue, startPoint: .top, endPoint: .bottom)
        )
    }

    func test_diagonal() {
        verify(
            SmoothLinearGradient(from: .green, to: .blue, startPoint: .topLeading, endPoint: .bottomTrailing)
        )
    }

    func test_stops() {
        verify(
            SmoothLinearGradient(
                from: .init(color: .green, location: 0.2),
                to: .init(color: .red, location: 0.4),
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension SmoothLinearGradientTests {
    func verify(
        _ gradient: SmoothLinearGradient,
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) {
        assertSnapshot(
            matching: gradient.frame(width: 256, height: 256),
            as: .image,
            file: file,
            testName: testName,
            line: line
        )
    }
}
#endif
#endif
