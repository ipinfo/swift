//
//  File.swift
//  
//
//  Created by mslm on 14/03/2023.
//

import Foundation
import UIKit
import Network
import SystemConfiguration.CaptiveNetwork

public let emptyString = ""

open class Constants{
    
    static let shared = Constants()
    
    /// Getting Application Version from info.plist
    static var APP_VERSION: String{
        return Bundle.main.appVersion ?? emptyString
    }
    
    static var APP_NAME: String{
        return Bundle.main.appName ?? emptyString
    }
    static var ACCESS_TOKEN: String{
        get{
            Bundle.main.accessToken ?? emptyString
        }
    }

}
struct UserDefaultKey {
    static let saveResultKey = "Saved Result"
}
