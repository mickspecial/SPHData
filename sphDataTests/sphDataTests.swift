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
		let exp = expectation(description: "callback closure")

		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .iso8601
		// Given: valid json file with empty records
		decoder.decode(MobileData.self, fromFile: "dataSet1") { testData in
			// Then: mobile data object is created with empty set of records
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
		// Given: valid json file with records
		decoder.decode(MobileData.self, fromFile: "dataSet2") { testData in
			// Then: mobile data object is created with records
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
		// Given: a record with default quarter date structure
		let record = Record(dataVolume: "", quarter: "2008-Q1", id: 0)
		// Then: year var should return only the year from that string, removes "-Q1"
		XCTAssertEqual(record.year, "2008")
	}

	func testGetQrtYearValueForQuarterDateFormat() {
		// Given: a record with default quarter date structure
		let record = Record(dataVolume: "", quarter: "2008-Q1", id: 0)
		// Then: quarterValue should remove the year and - removes "2008-"
		XCTAssertEqual(record.quarterValue, "Q1")
	}
	
	func testYearRecordCreationFromRecords() {
		let exp = expectation(description: "callback closure")

		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .iso8601
		// Given: valid json file with 5 records - 3 from 2005, 2 from 2004
		decoder.decode(MobileData.self, fromFile: "dataSet2") { testData in
			// Then: should return 2 YearRecords from initial 5 Records
			let yearly = testData.yearlyDataRecords()
			XCTAssertEqual(yearly.count, 2)
			let set1 = yearly.first(where: { $0.year == "2004" })
			XCTAssertNotNil(set1)
			let set2 = yearly.first(where: { $0.year == "2005" })
			XCTAssertNotNil(set2)
			exp.fulfill()
		}

		waitForExpectations(timeout: 1) { error in
			if let error = error {
				XCTFail("waitForExpectationsWithTimeout errored: \(error)")
			}
		}
	}

	func testYearRecordDataTotalFromRecords() {
		let exp = expectation(description: "callback closure")

		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .iso8601
		// Given: valid json file with 5 records - 3 from 2005, 2 from 2004
		decoder.decode(MobileData.self, fromFile: "dataSet2") { testData in
			let yearly = testData.yearlyDataRecords()
			// Then: yearly data totals should match expected values
			let set1 = yearly.first(where: { $0.year == "2004" })
			let set2 = yearly.first(where: { $0.year == "2005" })
			XCTAssertEqual(set1!.totalData, 0.000927)
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
		// Given: 2 records of different years
		let record = Record(dataVolume: "", quarter: "2008-Q1", id: 0)
		let record2 = Record(dataVolume: "", quarter: "2004-Q1", id: 0)
		let records = [record, record2]
		// Then: creating a YearRecord from those should fail
		let yearly = YearRecord(group: records)
		XCTAssertNil(yearly)
	}

	func testYearlyRecordDataTotal() {
		// Given: 4 records of matching years
		let record = Record(dataVolume: "1", quarter: "2008-Q1", id: 0)
		let record1 = Record(dataVolume: "2", quarter: "2008-Q2", id: 0)
		let record2 = Record(dataVolume: "3", quarter: "2008-Q3", id: 0)
		let record3 = Record(dataVolume: "4", quarter: "2008-Q4", id: 0)
		let records = [record, record1, record2, record3]
		let yearly = YearRecord(group: records)
		// Then: creating a YearRecord from those should pass
		// with correct totalData calculation
		XCTAssertNotNil(yearly)
		XCTAssertEqual(yearly!.totalData, 10)
	}
	
	func testYearlyRecordInvalidMismatchQuarterLimitExceeded() {
		// Given: 5 records of matching years
		let record = Record(dataVolume: "1", quarter: "2008-Q1", id: 0)
		let record1 = Record(dataVolume: "2", quarter: "2008-Q2", id: 0)
		let record2 = Record(dataVolume: "3", quarter: "2008-Q3", id: 0)
		let record3 = Record(dataVolume: "4", quarter: "2008-Q4", id: 0)
		let record4 = Record(dataVolume: "4", quarter: "2008-Q4", id: 0)
		let records = [record, record1, record2, record3, record4]
		// Then: creating a YearRecord from those should fail as it exceeds 4
		// only 1-4 records of the same year will create a YerRecord
		let yearly = YearRecord(group: records)
		XCTAssertNil(yearly)
	}
	
	func testYearlyRecordInvalidEmpty() {
		// Given: empty list of records
		let yearly = YearRecord(group: [Record]())
		// Then: creating a YearRecord should fail
		XCTAssertNil(yearly)
	}
	
	func testNoDecreaseInQrtDataForAYear() {
		// Given: 4 valid records with increasing dataVolumes for quarter after quarter
		let record = Record(dataVolume: "1", quarter: "2008-Q1", id: 0)
		let record1 = Record(dataVolume: "2", quarter: "2008-Q2", id: 0)
		let record2 = Record(dataVolume: "3", quarter: "2008-Q3", id: 0)
		let record3 = Record(dataVolume: "4", quarter: "2008-Q4", id: 0)
		// When: inital array is ordered by quarters or not
		let records = [record, record1, record2, record3].shuffled()
		let yearly = YearRecord(group: records)!
		// Then: all allQuartersDidGrow should return true
		XCTAssertTrue(yearly.allQuartersDidGrow)
	}
	
	func testDecreaseInQrtDataForAYear() {
		// Given: 4 valid records with a decrease in dataVolumes for a quarter
		let record = Record(dataVolume: "1", quarter: "2008-Q1", id: 0)
		let record1 = Record(dataVolume: "2", quarter: "2008-Q2", id: 0)
		let record2 = Record(dataVolume: "3", quarter: "2008-Q3", id: 0)
		let record3 = Record(dataVolume: "1", quarter: "2008-Q4", id: 0)
		let records = [record, record1, record2, record3].shuffled()
		let yearly = YearRecord(group: records)!
		// Then: all allQuartersDidGrow should return false as Q4 was less then Q3
		XCTAssertFalse(yearly.allQuartersDidGrow)
	}
	
	func testSameQrtDataForAYear() {
		// Given: valid records with a same in dataVolumes
		let record = Record(dataVolume: "1", quarter: "2008-Q1", id: 0)
		let record1 = Record(dataVolume: "1", quarter: "2008-Q2", id: 0)
		let records = [record, record1].shuffled()
		let yearly = YearRecord(group: records)!
		// Then: all allQuartersDidGrow should return true as only a decrease from quarter to quarter returns false
		XCTAssertTrue(yearly.allQuartersDidGrow)
	}
	
	func testNoDecreaseInQrtDataForAYearSingleQrt() {
		// Given: a single record
		let record = [Record(dataVolume: "10", quarter: "2008-Q1", id: 0)]
		let yearly = YearRecord(group: record)!
		// Then: all allQuartersDidGrow should return true there is no next quarter to compare against
		XCTAssertTrue(yearly.allQuartersDidGrow)
	}
	
	func testSortByQuarter() {
		// Given: 4 valid records, in any order
		let record = Record(dataVolume: "1", quarter: "2008-Q1", id: 0)
		let record1 = Record(dataVolume: "2", quarter: "2008-Q2", id: 0)
		let record2 = Record(dataVolume: "3", quarter: "2008-Q3", id: 0)
		let record3 = Record(dataVolume: "4", quarter: "2008-Q4", id: 0)
		let records = [record, record1, record2, record3].shuffled()
		// Then: sortedByQuarter should sort from Q1 to Q4
		let sorted = records.sortedByQuarter
		XCTAssertEqual(sorted.map({ $0.quarterValue }), ["Q1", "Q2", "Q3", "Q4"])
		XCTAssertEqual(sorted, [record, record1, record2, record3])
	}
}
