//
//  Continent.swift
//
//
//  Created by mslm on 22/11/2023.
//

import Foundation
public class Continent: Codable {
    
    // MARK: Lifecycle
    
    public init(
        code: String,
        name: String) {
            self.code = code
            self.name = name
        }
    
    // MARK: Public
    
    public let code: String
    public let name: String
    
}
