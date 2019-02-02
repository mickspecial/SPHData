//
//  MobileData.swift
//  sphData
//
//  Created by Michael Schembri on 1/2/19.
//  Copyright © 2019 Michael Schembri. All rights reserved.
//

import Foundation

struct MobileData: Codable {
	let success: Bool
	let records: [Record]

	// group all records with same year into dic
	// ie 2004: [Record], 2005: [Record] etc
	private func recordsByYear() -> [String: [Record]] {
		return Dictionary(grouping: records) { $0.year }
	}

	func yearlyDataRecords() -> [YearRecord] {
		let groupedByYear = recordsByYear()
		let tempData = groupedByYear.values.compactMap { YearRecord(group: $0) }
		return tempData.sorted()
	}
}

extension MobileData {
	enum CodingKeys: String, CodingKey {
		case success
		case result
		case records
	}

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		success = try container.decode(Bool.self, forKey: .success)
		let result = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .result)
		records = try result.decode([Record].self, forKey: .records)
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(success, forKey: .success)
		var result = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .result)
		try result.encode(records, forKey: .records)
	}
}
