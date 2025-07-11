//
//  File.swift
//
//
//

import Foundation
public struct Privacy: Codable, Sendable {
    
    // MARK: Lifecycle
    
    public init(
        vpn: Bool,
        proxy: Bool,
        tor: Bool,
        relay: Bool,
        hosting: Bool,
        service: String) {
            self.vpn = vpn
            self.proxy = proxy
            self.tor = tor
            self.relay = relay
            self.hosting = hosting
            self.service = service
        }
    
    // MARK: Public
    
    public let vpn: Bool
    public let proxy: Bool
    public let tor: Bool
    public let relay: Bool
    public let hosting: Bool
    public let service: String
    
}
