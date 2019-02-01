//
//  ViewController.swift
//  sphData
//
//  Created by Michael Schembri on 1/2/19.
//  Copyright © 2019 Michael Schembri. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		setUpController()
		fetchFromNetwork()
	}
	
	func setUpController() {
		title = "Mobile Data Usage"
		view.backgroundColor = Theme.current.backgroundColor
	}
	
	func fetchFromNetwork() {
		// all
		let testUrl = "https://data.gov.sg/api/action/datastore_search?resource_id=a807b7ab-6cad-4aa6-87d0-e283a7353a0f"
		// 5 only
		//let testUrl = "https://data.gov.sg/api/action/datastore_search?resource_id=a807b7ab-6cad-4aa6-87d0-e283a7353a0f&limit=5"
		// empty
		//let testUrl = "https://data.gov.sg/api/action/datastore_search?resource_id=a807b7ab-6cad-4aa6-87d0-e283a7353a0f&q=jones"

		// convert to model object if able to complete fetch
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .iso8601
		decoder.decode(MobileData.self, fromURL: testUrl) { data in
			let yearRecords = data.yearlyDataRecords()
			print(yearRecords)
		}
	}
}
