//
//  File.swift
//
//
//  Created by mslm on 22/11/2023.
//

import Foundation
public class ASN:Codable {
    public let asn: String
    public let name: String
    public let domain: String
    public let route: String
    public let type: String

    public init(
        asn: String,
        name: String,
        domain: String,
        route: String,
        type: String
    ) {
        self.asn = asn
        self.name = name
        self.domain = domain
        self.route = route
        self.type = type
    }
}
