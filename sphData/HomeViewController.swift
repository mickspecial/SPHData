//
//  ViewController.swift
//  sphData
//
//  Created by Michael Schembri on 1/2/19.
//  Copyright © 2019 Michael Schembri. All rights reserved.
//

import UIKit

class HomeViewController: UITableViewController {
	
	private let tableDataSource = HomeViewDataSource()

	override func viewDidLoad() {
		super.viewDidLoad()
		setUpController()
		setupTableView()
		checkLocalDataStore()
		fetchFromNetwork()
	}
	
	private func setUpController() {
		title = "Mobile Data Usage"
		view.backgroundColor = Theme.current.backgroundColor
	}
	
	private func setupTableView() {
		tableView.register(YearDataCell.self, forCellReuseIdentifier: YearDataCell.cellID)
		tableView.rowHeight = Theme.current.defaultCellHeight
		tableView.allowsSelection = false
		tableView.dataSource = tableDataSource
	}
	
	private func checkLocalDataStore() {
		if let data = DataStore.loadSavedData() {
			print("Local Data Used")
			refreshTableWithData(data: data)
		}
	}
	
	private func fetchFromNetwork() {
		// URLS >> all || 5 || empty
		let testUrl = "https://data.gov.sg/api/action/datastore_search?resource_id=a807b7ab-6cad-4aa6-87d0-e283a7353a0f"
		//let testUrl = "https://data.gov.sg/api/action/datastore_search?resource_id=a807b7ab-6cad-4aa6-87d0-e283a7353a0f&limit=5"
		//let testUrl = "https://data.gov.sg/api/action/datastore_search?resource_id=a807b7ab-6cad-4aa6-87d0-e283a7353a0f&q=jones"

		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .iso8601
		decoder.decode(MobileData.self, fromURL: testUrl) { [weak self] data in
			self?.refreshTableWithData(data: data)
			DataStore.saveData(data: data)
		}
	}
	
	private func refreshTableWithData(data: MobileData) {
		let yearly = data.yearlyDataRecords()
		tableDataSource.yearlyRecords = yearly
		tableView.reloadData()
	}
}
