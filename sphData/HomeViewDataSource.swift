//
//  HomeViewDataSource.swift
//  sphData
//
//  Created by Michael Schembri on 2/2/19.
//  Copyright © 2019 Michael Schembri. All rights reserved.
//

import UIKit

class HomeViewDataSource: NSObject, UITableViewDataSource {

	var yearlyRecords = [YearRecord]()
	weak var imageSelectionDelegate: HomeViewController?
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return yearlyRecords.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: YearDataCell.cellID, for: indexPath) as? YearDataCell else {
			fatalError("invalid cell type")
		}
		let data = yearlyRecords[indexPath.row]
		cell.data = data
		cell.iconButton.tag = indexPath.row
		cell.iconButton.addTarget(imageSelectionDelegate, action: #selector(HomeViewController.tapped), for: .touchUpInside)
		return cell
	}
}
