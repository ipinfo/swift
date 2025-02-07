//
//  File.swift
//
//
//

import Foundation
public class Abuse: Codable {
    
    // MARK: Lifecycle
    
    public init(
        address: String,
        country: String,
        email: String,
        name: String,
        network: String,
        phone: String) {
            self.address = address
            self.country = country
            self.email = email
            self.name = name
            self.network = network
            self.phone = phone
        }
    
    // MARK: Public
    
    public let address: String
    public let country: String
    public let email: String
    public let name: String
    public let network: String
    public let phone: String
    
}
