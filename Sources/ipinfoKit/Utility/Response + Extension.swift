//
//  File.swift
//  
//
//  Created by mslm on 14/03/2023.
//

import Foundation

public enum Response{
    /// The result of response serialization.
    case success, failure
    
    public var result: Bool{
        switch self {
        case .success:
            return true
        case .failure:
            return false
        }
    }
}
