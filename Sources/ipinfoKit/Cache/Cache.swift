//
//  File.swift
//
//
//  Created by ahmed on 2023-04-10.
//

import Foundation
import UIKit

class CachingManager {

	// MARK: Lifecycle

	private init() { }

	// MARK: Internal

	static let shared = CachingManager()

	func getDataFromCache() -> [String: IPResponse] {
		getCachedData(cache: resultCache, forKey: UserDefaultKey.saveResultKey)
	}

	func getASNDataFromCache() -> [String: ASNResponse] {
		getCachedData(cache: asnCache, forKey: UserDefaultKey.saveASNData)
	}

	func saveASNResult(_ result: [String: ASNResponse]) {
		saveDataToCache(cache: asnCache, data: result, forKey: UserDefaultKey.saveASNData)
	}

	func saveResult(_ result: [String: IPResponse]) {
		saveDataToCache(cache: resultCache, data: result, forKey: UserDefaultKey.saveResultKey)
	}

	// MARK: Private

	private let resultCache = NSCache<NSString, AnyObject>()
	private let asnCache = NSCache<NSString, AnyObject>()

	private let oneWeekInSeconds: TimeInterval = 7 * 24 * 60 * 60

	private func getCachedData<T>(cache: NSCache<NSString, AnyObject>, forKey key: String) -> [String: T] {
		if
			let cachedData = cache.object(forKey: key as NSString) as? CachedData<T>,
			Date() < cachedData.expirationDate {
			return cachedData.data
		} else {
			// Data is expired or not found in cache, remove it
			cache.removeObject(forKey: key as NSString)
			return [:]
		}
	}

	private func saveDataToCache<T>(cache: NSCache<NSString, AnyObject>, data: [String: T], forKey key: String) {
		let cachedData = CachedData(data: data, expirationDate: Date().addingTimeInterval(oneWeekInSeconds))
		cache.setObject(cachedData as AnyObject, forKey: key as NSString)
	}
}
