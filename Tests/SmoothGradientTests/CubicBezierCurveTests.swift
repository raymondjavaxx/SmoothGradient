//
//  CubicBezierCurveTests.swift
//  SmoothGradientTests
//
//  Copyright (c) 2023 Ramon Torres
//
//  This file is part of SmoothGradient which is released under the MIT license.
//  See the LICENSE file in the root directory of this source tree for full details.
//

import XCTest
@testable import SmoothGradient

final class CubicBezierCurveTests: XCTestCase {
    func test_easeInOut() throws {
        let expected: [Double] = [0, 0.129, 0.227, 0.5, 0.758, 0.870, 1]
        for (result, expectedValue) in zip(interpolate(.easeInOut), expected) {
            XCTAssertEqual(result, expectedValue, accuracy: 0.001)
        }
    }

    func test_easeIn() throws {
        let expected: [Double] = [0, 0.093, 0.153, 0.315, 0.503, 0.621, 1]
        for (result, expectedValue) in zip(interpolate(.easeIn), expected) {
            XCTAssertEqual(result, expectedValue, accuracy: 0.001)
        }
    }

    func test_easeOut() throws {
        let expected: [Double] = [0, 0.378, 0.484, 0.684, 0.838, 0.906, 1]
        for (result, expectedValue) in zip(interpolate(.easeOut), expected) {
            XCTAssertEqual(result, expectedValue, accuracy: 0.001)
        }
    }
}

extension CubicBezierCurveTests {
    private func interpolate(_ sut: CubicBezierCurve) -> [Double] {
        let steps: [Double] = [0, 0.25, 0.33, 0.5, 0.66, 0.75, 1]
        return steps.map { sut.value(at: $0) }
    }
}
