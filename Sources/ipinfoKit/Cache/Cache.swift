//
//  File.swift
//  
//
//  Created by ahmed on 2023-04-10.
//

import Foundation
import UIKit

extension UserDefaults {
    func set<T: Encodable>(encodable: T, forKey key: String) {
        if let data = try? JSONEncoder().encode(encodable) {
            set(data, forKey: key)
        }
    }
    
    func value<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
        if let data = object(forKey: key) as? Data,
           let value = try? JSONDecoder().decode(type, from: data) {
            return value
        }
        return nil
    }
}
extension IPINFO{
    internal func getDataFromCache() {
        Global.shared.Cache = UserDefaults.standard.value([String: Data].self, forKey: UserDefaultKey.saveResultKey) ?? [String: Data]()
    }
    
    
    internal func saveResult(_ result: [String: Data]) {
        /// Encoading Data
        UserDefaults.standard.set(encodable: result, forKey: UserDefaultKey.saveResultKey)
        getDataFromCache()
    }
    
}
