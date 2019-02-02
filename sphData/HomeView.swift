//
//  HomeView.swift
//  sphData
//
//  Created by Michael Schembri on 2/2/19.
//  Copyright © 2019 Michael Schembri. All rights reserved.
//

import UIKit

class HomeView: UIView {
	
	var tableView: UITableView = {
		let tv = UITableView()
		tv.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
		tv.rowHeight = Theme.current.defaultCellHeight
		tv.allowsSelection = false
		tv.translatesAutoresizingMaskIntoConstraints = false
		return tv
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupView()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setupView()
	}
	
	private func setupView() {
		addSubview(tableView)
		setupLayout()
	}
	
	private func setupLayout() {
		NSLayoutConstraint.activate([
		tableView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
		tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
		tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
		tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
		])
	}
}
