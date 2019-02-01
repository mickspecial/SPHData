//
//  sphDataTests.swift
//  sphDataTests
//
//  Created by Michael Schembri on 1/2/19.
//  Copyright © 2019 Michael Schembri. All rights reserved.
//

import XCTest
@testable import sphData

class sphDataTests: XCTestCase {

    func testCreateModelFromLocalFilesEmpty() {
		let e = expectation(description: "callback closure")

		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .iso8601
		decoder.decode(MobileData.self, fromFile: "dataSet1") { testData in
			XCTAssertTrue(testData.success)
			XCTAssertTrue(testData.records.isEmpty)
			e.fulfill()
		}
		
		waitForExpectations(timeout: 1) { error in
			if let error = error {
				XCTFail("waitForExpectationsWithTimeout errored: \(error)")
			}
		}
    }

	func testCreateModelFromLocalFilesNonEmpty() {
		let e = expectation(description: "callback closure")

		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .iso8601
		decoder.decode(MobileData.self, fromFile: "dataSet2") { testData in
			XCTAssertTrue(testData.success)
			XCTAssertEqual(testData.records.count, 5)
			e.fulfill()
		}
		
		waitForExpectations(timeout: 1) { error in
			if let error = error {
				XCTFail("waitForExpectationsWithTimeout errored: \(error)")
			}
		}
	}
}
