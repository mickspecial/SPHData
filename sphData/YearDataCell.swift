//
//  YearDataCell.swift
//  sphData
//
//  Created by Michael Schembri on 2/2/19.
//  Copyright © 2019 Michael Schembri. All rights reserved.
//

import UIKit

class YearDataCell: UITableViewCell {
	
	static let cellID = "yearCell"
	
	var data: YearRecord! {
		didSet {
			textLabel?.text = data.year // + " (\(data.quartersString))"
			let trimmedDouble = String(format: "%.4f", data.totalData)
			detailTextLabel?.text = "\(trimmedDouble) pb"
		}
	}
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
		textLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
		detailTextLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError()
	}
}
