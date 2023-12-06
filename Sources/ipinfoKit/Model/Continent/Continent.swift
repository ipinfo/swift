//
//  Continent.swift
//
//
//  Created by mslm on 22/11/2023.
//

import Foundation
public class Continent:Codable {
    public let code: String
    public let name: String

    public init(
        code: String,
        name: String
    ) {
        self.code = code
        self.name = name
    }
}
