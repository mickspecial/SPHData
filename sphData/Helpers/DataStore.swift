//
//  DataStore.swift
//  sphData
//
//  Created by Michael Schembri on 2/2/19.
//  Copyright © 2019 Michael Schembri. All rights reserved.
//

import Foundation

struct DataStore {
	
	static let cacheKey = "cache"
	
	static func loadSavedData() -> MobileData? {
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .iso8601
		if let data = UserDefaults.standard.data(forKey: cacheKey), let savedData = try? decoder.decode(MobileData.self, from: data) {
			return savedData
		}
		print("No saved data found")
		return nil
	}
	
	static func saveData(data: MobileData) {
		let encoder = JSONEncoder()
		encoder.dateEncodingStrategy = .iso8601
		
		if let encodedUser = try? encoder.encode(data) {
			print("Saved")
			UserDefaults.standard.set(encodedUser, forKey: cacheKey)
		} else {
			print("Failed Save")
		}
	}
}
