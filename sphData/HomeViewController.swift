//
//  ViewController.swift
//  sphData
//
//  Created by Michael Schembri on 1/2/19.
//  Copyright © 2019 Michael Schembri. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
	
	private let tableDataSource = HomeViewDataSource()
	var homeView: HomeView {
		return view as! HomeView
	}
		
	override func loadView() {
		view = HomeView()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setUpController()
		setupTableView()
		fetchFromNetwork()
	}
	
	func setUpController() {
		title = "Mobile Data Usage"
		view.backgroundColor = Theme.current.backgroundColor
	}
	
	private func setupTableView() {
		view.addSubview(homeView.tableView)
		homeView.tableView.delegate = self
		homeView.tableView.register(YearDataCell.self, forCellReuseIdentifier: YearDataCell.cellID)
		homeView.tableView.dataSource = tableDataSource
		tableDataSource.setDataSource()
	}
	
	func fetchFromNetwork() {
		// URLS >> all || 5 || empty
		let testUrl = "https://data.gov.sg/api/action/datastore_search?resource_id=a807b7ab-6cad-4aa6-87d0-e283a7353a0f"
		//let testUrl = "https://data.gov.sg/api/action/datastore_search?resource_id=a807b7ab-6cad-4aa6-87d0-e283a7353a0f&limit=5"
		//let testUrl = "https://data.gov.sg/api/action/datastore_search?resource_id=a807b7ab-6cad-4aa6-87d0-e283a7353a0f&q=jones"

		// convert to model object if able to complete fetch
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .iso8601
		decoder.decode(MobileData.self, fromURL: testUrl) { [weak self] data in
			let yearly = data.yearlyDataRecords()
			self?.tableDataSource.setDataSource(data: yearly)
			self?.homeView.tableView.reloadData()
		}
	}
}

extension HomeViewController: UITableViewDelegate {

}
