//
//  File.swift
//
//
//

import Foundation
public class Carrier: Codable {
    
    // MARK: Lifecycle
    
    public init(
        name: String,
        mcc: String,
        mnc: String) {
            self.name = name
            self.mcc = mcc
            self.mnc = mnc
        }
    
    // MARK: Public
    
    public let name: String
    public let mcc: String
    public let mnc: String
    
}
