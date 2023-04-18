//
//  Global.swift
//  Care 20 Doctor
//
//  Created by hmbl Apps on 04/10/2022.
//

import Foundation
class Global{
    static let shared = Global()
    
    private init(){}
    
   var Cache = [String: Data]()
    
    var keys = [String]()
    
}
