//
//  Domains.swift
//
//
//  Created by mslm on 22/11/2023.
//

import Foundation
public class Domains: Codable {
    public let total: Int
    public let domains: [String]

    public init(
        total: Int,
        domains: [String]
    ) {
        self.total = total
        self.domains = domains
    }

    public var description: String {
        return "Domains{total='\(total)', domains=\(domains)}"
    }
}
