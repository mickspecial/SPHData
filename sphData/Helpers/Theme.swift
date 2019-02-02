//
//  Theme.swift
//  sphData
//
//  Created by Michael Schembri on 1/2/19.
//  Copyright © 2019 Michael Schembri. All rights reserved.
//

import UIKit

enum Theme {
	static var current: ThemeProtocol = DefaultTheme()
}

protocol ThemeProtocol {
	var backgroundColor: UIColor { get }
	var defaultCellHeight: CGFloat { get }
	var defaultTextColor: UIColor { get }
	var redTextColor: UIColor { get }
}

class DefaultTheme: ThemeProtocol {
	var backgroundColor: UIColor { return UIColor.lightGray }
	var defaultCellHeight: CGFloat { return 80 }
	var defaultTextColor: UIColor { return UIColor.black }
	var redTextColor: UIColor { return UIColor.red }
}
