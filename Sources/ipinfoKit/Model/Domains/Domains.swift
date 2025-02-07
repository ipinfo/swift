//
//  Domains.swift
//
//
//

import Foundation
public class Domains: Codable {
    
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
