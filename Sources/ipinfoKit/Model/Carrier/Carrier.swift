//
//  File.swift
//
//
//  Created by mslm on 22/11/2023.
//

import Foundation
public class Carrier: Codable {
    public let name: String
    public let mcc: String
    public let mnc: String

    public init(
        name: String,
        mcc: String,
        mnc: String
    ) {
        self.name = name
        self.mcc = mcc
        self.mnc = mnc
    }

    public var description: String {
        return "Carrier{name='\(name)', mcc='\(mcc)', mnc='\(mnc)'}"
    }
}
