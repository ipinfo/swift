//
//  File.swift
//
//
//  Created by mslm on 06/12/2023.
//

import Foundation
struct CachedData<T> {
	let data: [String: T]
	let expirationDate: Date
}
