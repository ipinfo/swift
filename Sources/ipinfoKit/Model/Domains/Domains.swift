//
//  Domains.swift
//
//
//  Created by mslm on 22/11/2023.
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
