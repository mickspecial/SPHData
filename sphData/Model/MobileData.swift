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

extension MobileData {
	enum CodingKeys: String, CodingKey {
		case success
		case result
		case records
	}
}

extension MobileData {
	
	static func create(fromFile fileName: String) -> MobileData {
		guard let url = Bundle.main.url(forResource: fileName, withExtension:"json") else {
			fatalError("Unable to locate file \(fileName).json")
		}
		
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .iso8601
		
		guard let data = try? Data(contentsOf: url), let mobileData = try? decoder.decode(MobileData.self, from: data) else {
			fatalError("Unable to convert json")
		}
		
		return mobileData
	}
}
