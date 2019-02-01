//
//  Record.swift
//  sphData
//
//  Created by Michael Schembri on 1/2/19.
//  Copyright © 2019 Michael Schembri. All rights reserved.
//

import Foundation

struct Record: Codable {
	let dataVolume: String
	let quarter: String
	let id: Int
	
	var dataVolumeDouble: Double {
		let asDouble = Double(dataVolume)
		assert(asDouble != nil, "Data volume could not be transformed to Double: \(dataVolume)")
		return asDouble!
	}
	
	var year: String {
		assert(quarter.count == 7, "Assumed all dates returned have 7 characters")
		return String(quarter.prefix(4))
	}
}

extension Record {
	enum CodingKeys: String, CodingKey {
		case dataVolume = "volume_of_mobile_data"
		case quarter = "quarter"
		case id = "_id"
	}
}
