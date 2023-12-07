//
//  File.swift
//
//
//  Created by mslm on 14/03/2023.
//

import Foundation
import UIKit

public let emptyString = ""

// MARK: - Constants

open class Constants {
    
	static let shared = Constants()

	/// Getting Application Version from info.plist
	static var APP_VERSION: String {
		Bundle.main.appVersion ?? emptyString
	}
    
	static var APP_NAME: String {
		Bundle.main.appName ?? emptyString
	}
    
	static var ACCESS_TOKEN: String {
		Bundle.main.accessToken ?? emptyString
	}

}

// MARK: - UserDefaultKey

enum UserDefaultKey {
	static let saveResultKey = "Saved Result"
	static let saveASNData = "SAVE_ASN_DATA"
}
