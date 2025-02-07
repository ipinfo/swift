//
//  File.swift
//
//
//

import Foundation
public class ASN: Codable {
    
    // MARK: Lifecycle
    
    public init(
        asn: String,
        name: String,
        domain: String,
        route: String,
        type: String) {
            self.asn = asn
            self.name = name
            self.domain = domain
            self.route = route
            self.type = type
        }
    
    // MARK: Public
    
    public let asn: String
    public let name: String
    public let domain: String
    public let route: String
    public let type: String
    
}
