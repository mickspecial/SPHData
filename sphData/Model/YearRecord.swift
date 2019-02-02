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
	
	var quartersString: String {
		// ie Q4・Q3
		return quarters.map({ $0.quarterValue }).joined(separator: "・")
	}
	
	var allQuartersDidGrow: Bool {
		// order the records according to Qrt
		let sorted = quarters.sortedByQuarter
		// convert case record into its dataVolume
		let orderQuarterlyDownloads = sorted.map({ $0.dataVolume })
		let smallestToLargest = quarters.map({ $0.dataVolume }).sorted(by: { $0 < $1 })
		// if arrays equal can assert that downloads + or remainded the same qrt after qrt
		return orderQuarterlyDownloads == smallestToLargest
	}
	
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
