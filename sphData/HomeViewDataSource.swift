//
//  HomeViewDataSource.swift
//  sphData
//
//  Created by Michael Schembri on 2/2/19.
//  Copyright © 2019 Michael Schembri. All rights reserved.
//

import UIKit

class HomeViewDataSource: NSObject, UITableViewDataSource {

	private (set) var yearlyRecords = [YearRecord]()
	
	func setDataSource(data: [YearRecord] = [YearRecord]()) {
		yearlyRecords = data
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return yearlyRecords.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: YearDataCell.cellID, for: indexPath) as! YearDataCell
		let data = yearlyRecords[indexPath.row]
		cell.data = data
		return cell
	}

}
