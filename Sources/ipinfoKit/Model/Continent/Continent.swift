//
//  Continent.swift
//
//
//  Created by mslm on 22/11/2023.
//

import Foundation
public class Continent {
    public let code: String
    public let name: String

    public init(
        code: String,
        name: String
    ) {
        self.code = code
        self.name = name
    }

    public var description: String {
        return "Continent{code='\(code)', name='\(name)'}"
    }
}
