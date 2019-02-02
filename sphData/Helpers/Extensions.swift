//
//  Extensions.swift
//  sphData
//
//  Created by Michael Schembri on 1/2/19.
//  Copyright © 2019 Michael Schembri. All rights reserved.
//

import UIKit

extension JSONDecoder {
	
	func decode<T: Decodable>(_ type: T.Type, fromURL url: String, completion: @escaping (T) -> Void) {
		guard let url = URL(string: url) else {
			fatalError("Invalid URL passed.")
		}
		
		DispatchQueue.global().async {
			do {
				let data = try Data(contentsOf: url)
				let downloaded = try self.decode(type, from: data)
				
				DispatchQueue.main.async {
					completion(downloaded)
				}
			} catch {
				print(error.localizedDescription)
			}
		}
	}
	
	func decode<T: Decodable>(_ type: T.Type, fromFile fileName: String, completion: @escaping (T) -> Void) {
		guard let url = Bundle.main.url(forResource: fileName, withExtension:"json") else {
			fatalError("Unable to locate file \(fileName).json")
		}

		DispatchQueue.global().async {
			do {
				let data = try Data(contentsOf: url)
				let downloaded = try self.decode(type, from: data)

				DispatchQueue.main.async {
					completion(downloaded)
				}
			} catch {
				print(error.localizedDescription)
			}
		}
	}
}

extension Collection where Element == YearRecord {
	var sortedByYear: [YearRecord] {
		return self.sorted(by: { $0.year < $1.year })
	}
}

extension Collection where Element == Record {
	var sortedByQuarter: [Record] {
		return self.sorted(by: { $0.quarterValue < $1.quarterValue })
	}
}

extension UIImage {
	func tinted(with color: UIColor) -> UIImage? {
		UIGraphicsBeginImageContextWithOptions(size, false, scale)
		defer { UIGraphicsEndImageContext() }
		color.set()
		withRenderingMode(.alwaysTemplate).draw(in: CGRect(origin: .zero, size: size))
		return UIGraphicsGetImageFromCurrentImageContext()
	}
}
