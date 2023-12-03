//
//  Prefix.swift
//
//
//  Created by mslm on 29/11/2023.
//

import Foundation

struct Prefix:Codable {
    let netblock: String
    let id: String
    let name: String
    let country: String
    let size: String
    let status: String
    let domain: String

    init(
        netblock: String,
        id: String,
        name: String,
        country: String,
        size: String,
        status: String,
        domain: String
    ) {
        self.netblock = netblock
        self.id = id
        self.name = name
        self.country = country
        self.size = size
        self.status = status
        self.domain = domain
    }

    func toString() -> String {
        return """
        Prefix{
            netblock='\(netblock)',
            id='\(id)',
            name='\(name)',
            country='\(country)',
            size='\(size)',
            status='\(status)',
            domain='\(domain)'
        }
        """
    }
}
