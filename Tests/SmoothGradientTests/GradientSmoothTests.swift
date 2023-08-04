//
//  GradientSmoothTests.swift
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

final class GradientSmoothTests: XCTestCase {
    func test_easing_easeInOut() throws {
        verify(
            .smooth(from: .black, to: .black.opacity(0), easing: .easeInOut)
        )
    }

    func test_easing_easeIn() throws {
        verify(
            .smooth(from: .black, to: .black.opacity(0), easing: .easeIn)
        )
    }

    func test_easing_easeOut() throws {
        verify(
            .smooth(from: .black, to: .black.opacity(0), easing: .easeOut)
        )
    }

    func test_easing_stops() throws {
        verify(
            .smooth(
                from: .init(color: .green, location: 0.2),
                to: .init(color: .red, location: 0.4),
                easing: .easeInOut
            )
        )
    }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension GradientSmoothTests {
    func test_curve_easeInOut() throws {
        verify(
            .smooth(from: .black, to: .black.opacity(0), curve: .easeInOut)
        )
    }

    func test_curve_easeIn() throws {
        verify(
            .smooth(from: .black, to: .black.opacity(0), curve: .easeIn)
        )
    }

    func test_curve_easeOut() throws {
        verify(
            .smooth(from: .black, to: .black.opacity(0), easing: .easeOut)
        )
    }

    func test_curve_stops() throws {
        verify(
            .smooth(
                from: .init(color: .green, location: 0.2),
                to: .init(color: .red, location: 0.4),
                curve: .easeInOut
            )
        )
    }
}

extension GradientSmoothTests {
    func verify(
        _ gradient: Gradient,
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) {
        let rectangle = Rectangle()
            .frame(width: 256, height: 256)
            .foregroundStyle(
                LinearGradient(
                    gradient: gradient,
                    startPoint: .top,
                    endPoint: .bottom
                )
            )

        assertSnapshot(
            matching: rectangle,
            as: .image,
            file: file,
            testName: testName,
            line: line
        )
    }
}
