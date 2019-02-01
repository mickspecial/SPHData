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
		// test URL
		let testUrl = "https://data.gov.sg/api/action/datastore_search?resource_id=a807b7ab-6cad-4aa6-87d0-e283a7353a0f&limit=5"
		//let testUrl = "https://data.gov.sg/api/action/datastore_search?resource_id=a807b7ab-6cad-4aa6-87d0-e283a7353a0f&q=jones"

		// test fetch data
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .iso8601
		
		guard let url = URL(string: testUrl) else {
			fatalError("Invalid URL passed.")
		}
		
		DispatchQueue.global().async {
			do {
				let data = try Data(contentsOf: url)
				let downloaded = try decoder.decode(MobileData.self, from: data)
				
				DispatchQueue.main.async {
					print(downloaded)
				}
			} catch {
				print(error.localizedDescription)
			}
		}
	}
}
