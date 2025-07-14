//
//  File.swift
//
//
//

import Foundation

extension Bundle {
    /// Fetching Api Key from Info.plist
    var accessToken: String? {
      return object(forInfoDictionaryKey: "IPInfoKitAccessToken") as? String
    }
    
    /// Fetching App Version from Info.plist
    var appVersion: String? {
        object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
    
    /// Fetching App Name from Info.plist
    var appName: String? {
        object(forInfoDictionaryKey: "CFBundleName") as? String
    }
    
}
