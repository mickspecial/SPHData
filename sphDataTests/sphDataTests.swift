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
		let testData = MobileData.create(fromFile: "dataSet1")
		XCTAssertTrue(testData.success)
		XCTAssertTrue(testData.records.isEmpty)
    }
	
	func testCreateModelFromLocalFilesNonEmpty() {
		let testData = MobileData.create(fromFile: "dataSet2")
		XCTAssertTrue(testData.success)
		XCTAssertEqual(testData.records.count, 5)
	}
}
