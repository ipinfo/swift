//
//  Array.swift
//  
//
//  Created by mslm on 07/12/2023.
//

import Foundation
extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
