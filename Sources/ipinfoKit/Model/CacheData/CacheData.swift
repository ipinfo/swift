//
//  File.swift
//
//
//

import Foundation
struct CachedData<T> {
    let data: [String: T]
    let expirationDate: Date
}
