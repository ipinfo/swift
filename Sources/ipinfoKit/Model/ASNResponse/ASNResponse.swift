//
//  ASNResponse.swift
//
//
//  Created by mslm on 29/11/2023.
//

import Foundation

public struct ASNResponse:Codable {
    
    let asn: String?
    let name: String?
    let country: String?
    let allocated: String?
    let registry: String?
    let domain: String?
    let numIPS: Int?
    let type: String?
    let prefixes: [Prefix]?
    let prefixes6: [Prefix]?
    let peers: [String]?
    let upstreams: [String]?
    let downstreams: [String]?
    var context = CountryData()
    var countryName: String{
        context.getCountryName(self.country ?? "")
    }
    
    enum CodingKeys: String, CodingKey {
        case asn = "asn"
        case name = "name"
        case country = "country"
        case allocated = "allocated"
        case registry = "registry"
        case domain = "domain"
        case numIPS = "num_ips"
        case type = "type"
        case prefixes = "prefixes"
        case prefixes6 = "prefixes6"
        case peers = "peers"
        case upstreams = "upstreams"
        case downstreams = "downstreams"
    }
    
    init(
        asn: String,
        name: String,
        country: String,
        allocated: String,
        registry: String,
        domain: String,
        numIps: Int?,
        type: String,
        prefixes: [Prefix],
        prefixes6: [Prefix],
        peers: [String],
        upstreams: [String],
        downstreams: [String]
    ) {
        self.asn = asn
        self.name = name
        self.country = country
        self.allocated = allocated
        self.registry = registry
        self.domain = domain
        self.numIPS = numIps ?? 0
        self.type = type
        self.prefixes = prefixes
        self.prefixes6 = prefixes6
        self.peers = peers
        self.upstreams = upstreams
        self.downstreams = downstreams
        
    }
    
}
