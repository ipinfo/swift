//
//  File.swift
//
//
//

import Foundation

public enum Response {
    /// The result of response serialization.
    case success, failure
    
    public var result: Bool {
        switch self {
        case .success:
            true
        case .failure:
            false
        }
    }
}
