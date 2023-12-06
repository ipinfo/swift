//
//  File.swift
//  
//
//  Created by mslm on 22/11/2023.
//

import Foundation
public class Company:Codable {
    public let name: String
    public let domain: String
    public let type: String

    public init(
        name: String,
        domain: String,
        type: String
    ) {
        self.name = name
        self.domain = domain
        self.type = type
    }
}
