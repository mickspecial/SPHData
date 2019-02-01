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
}

extension Record {
	enum CodingKeys: String, CodingKey {
		case dataVolume = "volume_of_mobile_data"
		case quarter = "quarter"
		case id = "_id"
	}
}
