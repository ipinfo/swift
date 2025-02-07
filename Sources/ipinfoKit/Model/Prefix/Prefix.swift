//
//  Prefix.swift
//
//
//

import Foundation

struct Prefix: Codable {
    
    // MARK: Lifecycle
    
    init(
        netblock: String,
        id: String,
        name: String,
        country: String,
        size: String,
        status: String,
        domain: String) {
            self.netblock = netblock
            self.id = id
            self.name = name
            self.country = country
            self.size = size
            self.status = status
            self.domain = domain
        }
    
    // MARK: Internal
    
    let netblock: String
    let id: String
    let name: String
    let country: String
    let size: String
    let status: String
    let domain: String
    
}
