//
//  File.swift
//
//
//

import Foundation
public class Company: Codable {
    
    // MARK: Lifecycle
    
    public init(
        name: String,
        domain: String,
        type: String) {
            self.name = name
            self.domain = domain
            self.type = type
        }
    
    // MARK: Public
    
    public let name: String
    public let domain: String
    public let type: String
    
}
