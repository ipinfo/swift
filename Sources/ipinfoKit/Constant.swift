import Foundation

// MARK: - Constants

@MainActor
open class Constants {
    
    static let shared = Constants()
    
    /// Getting Application Version from info.plist
    static var APP_VERSION: String {
        Bundle.main.appVersion ?? ""
    }
    
    static var APP_NAME: String {
        Bundle.main.appName ?? ""
    }
    
    static var ACCESS_TOKEN: String {
      Bundle.main.accessToken ?? ProcessInfo.processInfo.environment["IPInfoKitAccessToken"] ?? ""
    }
    
}

// MARK: - UserDefaultKey

enum UserDefaultKey {
    static let saveResultKey = "Saved Result"
    static let saveASNData = "SAVE_ASN_DATA"
}
