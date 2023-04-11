//
//  File.swift
//  
//
//  Created by ahmed on 2023-04-09.
//

import Foundation
extension IPINFO{
    func isBogonIP(_ ipAddress: String) -> Bool {
        let ipString = ipAddress.prefix(while: { $0 != "/" })
        let bogonRanges = [
            "0.0.0.0/8", // Current network (RFC 1122)
            "10.0.0.0/8", // Private network
            "127.0.0.0/8", // Loopback
            "169.254.0.0/16", // Link-local
            "172.16.0.0/12", // Private network
            "192.0.0.0/24", // Reserved (RFC 6890)
            "192.0.2.0/24", // Documentation (RFC 6890)
            "192.88.99.0/24", // 6to4 relay anycast (RFC 3068)
            "192.168.0.0/16", // Private network
            "198.18.0.0/15", // Network benchmark tests (RFC 2544)
            "198.51.100.0/24", // Documentation (RFC 6890)
            "203.0.113.0/24", // Documentation (RFC 6890)
            "224.0.0.0/4", // Multicast (RFC 5771)
            "240.0.0.0/4" // Reserved (RFC 1112)
        ]

        for range in bogonRanges {
            let cidrComponents = range.split(separator: "/")
            let ipRange = cidrComponents[0]
            let subnetMask = UInt32(cidrComponents[1])!
            let ipAddressInt = ipToUInt32(String(ipString))
            let ipRangeInt = ipToUInt32(String(ipRange))
            let subnetMaskInt = (0xFFFFFFFF as UInt32) << (32 - subnetMask)
            if (ipAddressInt & subnetMaskInt) == (ipRangeInt & subnetMaskInt) {
                return true
            }
        }
        return false
    }
    func ipToUInt32(_ ipAddress: String) -> UInt32 {
        let parts = ipAddress.split(separator: ".").map { UInt8($0)! }
        return (UInt32(parts[0]) << 24) | (UInt32(parts[1]) << 16) | (UInt32(parts[2]) << 8) | UInt32(parts[3])
    }
}
