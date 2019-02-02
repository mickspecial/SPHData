//
//  sphDataTests.swift
//  sphDataTests
//
//  Created by Michael Schembri on 1/2/19.
//  Copyright © 2019 Michael Schembri. All rights reserved.
//

import XCTest
@testable import sphData
// swiftlint:disable all

class sphDataTests: XCTestCase {

    func testCreateModelFromLocalFilesEmpty() {
		let exp = expectation(description: "callback closure")

		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .iso8601
		decoder.decode(MobileData.self, fromFile: "dataSet1") { testData in
			XCTAssertTrue(testData.success)
			XCTAssertTrue(testData.records.isEmpty)
			exp.fulfill()
		}

		waitForExpectations(timeout: 1) { error in
			if let error = error {
				XCTFail("waitForExpectationsWithTimeout errored: \(error)")
			}
		}
    }

	func testCreateModelFromLocalFilesNonEmpty() {
		let exp = expectation(description: "callback closure")

		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .iso8601
		decoder.decode(MobileData.self, fromFile: "dataSet2") { testData in
			XCTAssertTrue(testData.success)
			XCTAssertEqual(testData.records.count, 5)
			exp.fulfill()
		}

		waitForExpectations(timeout: 1) { error in
			if let error = error {
				XCTFail("waitForExpectationsWithTimeout errored: \(error)")
			}
		}
	}

	func testGetYearValueForQuarterDateFormat() {
		let record = Record(dataVolume: "", quarter: "2008-Q1", id: 0)
		XCTAssertEqual(record.year, "2008")
	}

	func testGetQrtYearValueForQuarterDateFormat() {
		let record = Record(dataVolume: "", quarter: "2008-Q1", id: 0)
		XCTAssertEqual(record.quarterValue, "Q1")
	}
	
	func testYearly() {
		let exp = expectation(description: "callback closure")

		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .iso8601
		decoder.decode(MobileData.self, fromFile: "dataSet2") { testData in
			let yearly = testData.yearlyDataRecords()
			XCTAssertEqual(yearly.count, 2)
			let set1 = yearly.first(where: { $0.year == "2004" })
			XCTAssertNotNil(set1)
			XCTAssertEqual(set1!.totalData, 0.000927)
			let set2 = yearly.first(where: { $0.year == "2005" })
			XCTAssertNotNil(set2)
			XCTAssertEqual(set2!.totalData, 0.001972)
			exp.fulfill()
		}

		waitForExpectations(timeout: 1) { error in
			if let error = error {
				XCTFail("waitForExpectationsWithTimeout errored: \(error)")
			}
		}
	}

	func testYearlyRecordInvalidMismatchYearValues() {
		let record = Record(dataVolume: "", quarter: "2008-Q1", id: 0)
		let record2 = Record(dataVolume: "", quarter: "2004-Q1", id: 0)
		let records = [record, record2]
		let yearly = YearRecord(group: records)
		XCTAssertNil(yearly)
	}

	func testYearlyRecordDataTotal() {
		let record = Record(dataVolume: "1", quarter: "2008-Q1", id: 0)
		let record1 = Record(dataVolume: "2", quarter: "2008-Q2", id: 0)
		let record2 = Record(dataVolume: "3", quarter: "2008-Q3", id: 0)
		let record3 = Record(dataVolume: "4", quarter: "2008-Q4", id: 0)
		let records = [record, record1, record2, record3]
		let yearly = YearRecord(group: records)
		XCTAssertNotNil(yearly)
		XCTAssertEqual(yearly!.totalData, 10)
	}
	
	func testYearlyRecordInvalidMismatchQuarterLimitExceeded() {
		let record = Record(dataVolume: "1", quarter: "2008-Q1", id: 0)
		let record1 = Record(dataVolume: "2", quarter: "2008-Q2", id: 0)
		let record2 = Record(dataVolume: "3", quarter: "2008-Q3", id: 0)
		let record3 = Record(dataVolume: "4", quarter: "2008-Q4", id: 0)
		let record4 = Record(dataVolume: "4", quarter: "2008-Q4", id: 0)
		let records = [record, record1, record2, record3, record4]
		let yearly = YearRecord(group: records)
		XCTAssertNil(yearly)
	}
	
	func testYearlyRecordInvalidEmpty() {
		let yearly = YearRecord(group: [Record]())
		XCTAssertNil(yearly)
	}
	
	func testNoDecreaseInQrtDataForAYear() {
		let record = Record(dataVolume: "1", quarter: "2008-Q1", id: 0)
		let record1 = Record(dataVolume: "2", quarter: "2008-Q2", id: 0)
		let record2 = Record(dataVolume: "3", quarter: "2008-Q3", id: 0)
		let record3 = Record(dataVolume: "4", quarter: "2008-Q4", id: 0)
		let records = [record, record1, record2, record3].shuffled()
		let yearly = YearRecord(group: records)!
		XCTAssertTrue(yearly.allQuartersDidGrow)
	}
	
	func testDecreaseInQrtDataForAYear() {
		let record = Record(dataVolume: "1", quarter: "2008-Q1", id: 0)
		let record1 = Record(dataVolume: "2", quarter: "2008-Q2", id: 0)
		let record2 = Record(dataVolume: "3", quarter: "2008-Q3", id: 0)
		let record3 = Record(dataVolume: "1", quarter: "2008-Q4", id: 0)
		let records = [record, record1, record2, record3].shuffled()
		let yearly = YearRecord(group: records)!
		XCTAssertFalse(yearly.allQuartersDidGrow)
	}
	
	func testSameQrtDataForAYear() {
		let record = Record(dataVolume: "1", quarter: "2008-Q1", id: 0)
		let record1 = Record(dataVolume: "1", quarter: "2008-Q2", id: 0)
		let records = [record, record1].shuffled()
		let yearly = YearRecord(group: records)!
		XCTAssertTrue(yearly.allQuartersDidGrow)
	}
	
	func testNoDecreaseInQrtDataForAYearSingleQrt() {
		let record = [Record(dataVolume: "10", quarter: "2008-Q1", id: 0)]
		let yearly = YearRecord(group: record)!
		XCTAssertTrue(yearly.allQuartersDidGrow)
	}
	
	func testSortByQuarter() {
		let record = Record(dataVolume: "1", quarter: "2008-Q1", id: 0)
		let record1 = Record(dataVolume: "2", quarter: "2008-Q2", id: 0)
		let record2 = Record(dataVolume: "3", quarter: "2008-Q3", id: 0)
		let record3 = Record(dataVolume: "4", quarter: "2008-Q4", id: 0)
		let records = [record, record1, record2, record3].shuffled()
		let sorted = records.sortedByQuarter
		XCTAssertEqual(sorted.map({ $0.quarterValue }), ["Q1", "Q2", "Q3", "Q4"])
		XCTAssertEqual(sorted, [record, record1, record2, record3])
	}
}
