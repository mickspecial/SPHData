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
	}
	
	func setUpController() {
		title = "Mobile Data Usage"
		view.backgroundColor = Theme.current.backgroundColor
	}
}

