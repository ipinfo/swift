//
//  File.swift
//
//
//  Created by mslm on 22/11/2023.
//

import Foundation
public class Abuse: Codable {
    public let address: String
    public let country: String
    public let email: String
    public let name: String
    public let network: String
    public let phone: String

    public init(
        address: String,
        country: String,
        email: String,
        name: String,
        network: String,
        phone: String
    ) {
        self.address = address
        self.country = country
        self.email = email
        self.name = name
        self.network = network
        self.phone = phone
    }
}
