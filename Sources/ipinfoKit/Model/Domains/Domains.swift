//
//  Domains.swift
//
//
//

import Foundation
public struct Domains: Codable, Sendable {
    
    // MARK: Lifecycle
    
    public init(
        total: Int,
        domains: [String]) {
            self.total = total
            self.domains = domains
        }
    
    // MARK: Public
    
    public let total: Int
    public let domains: [String]
    
}
