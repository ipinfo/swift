//
//  Continent.swift
//
//
//

import Foundation
public struct Continent: Codable, Sendable {
    
    // MARK: Lifecycle
    
    public init(
        code: String,
        name: String) {
            self.code = code
            self.name = name
        }
    
    // MARK: Public
    
    public let code: String
    public let name: String
    
}
