//
//  YearRecord.swift
//  sphData
//
//  Created by Michael Schembri on 1/2/19.
//  Copyright © 2019 Michael Schembri. All rights reserved.
//

import Foundation

struct YearRecord {
	let year: String
	let totalData: Double
	let quarters: [Record]
	
	init?(group: [Record]) {
		let years = Set(group.map({ $0.year }))
		if group.isEmpty || group.count > 4 || years.count > 1 {
			print("year group was not created")
			return nil
		}

		self.quarters = group
		self.year = group.first!.year
		self.totalData = group.reduce(0) { return $0 + $1.dataVolumeDouble }
	}
}
