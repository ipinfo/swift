//
//  IPResponse.swift
//
//
//  Created by mslm on 22/11/2023.
//

import Foundation

public struct IPResponse: Codable {
    let ip: String?
    let hostname: String?
    let bogon: Bool?
    let anycast: Bool?
    let city: String?
    let region: String?
    let country: String?
    let loc: String?
    let org: String?
    let postal: String?
    let timezone: String?
    let asn: ASN?
    let company: Company?
    let carrier: Carrier?
    let privacy: Privacy?
    let abuse: Abuse?
    let domains: Domains?
    var context = CountryData()
    var readme: String?
    
   init(
        ip: String,
        hostname: String?,
        bogon: Bool,
        anycast: Bool,
        city: String?,
        region: String?,
        country: String?,
        loc: String?,
        org: String?,
        postal: String?,
        timezone: String?,
        asn: ASN?,
        company: Company?,
        carrier: Carrier?,
        privacy: Privacy?,
        abuse: Abuse?,
        domains: Domains?
    ) {
        self.ip = ip
        self.hostname = hostname
        self.bogon = bogon
        self.anycast = anycast
        self.city = city
        self.region = region
        self.country = country
        self.loc = loc
        self.org = org
        self.postal = postal
        self.timezone = timezone
        self.asn = asn
        self.company = company
        self.carrier = carrier
        self.privacy = privacy
        self.abuse = abuse
        self.domains = domains
    }
    enum CodingKeys: String, CodingKey {
        case ip = "ip"
        case hostname = "hostname"
        case bogon = "bogon"
        case anycast = "anycast"
        case city = "city"
        case region = "region"
        case country = "country"
        case loc = "loc"
        case org = "org"
        case postal = "postal"
        case timezone = "timezone"
        case asn = "asn"
        case company = "company"
        case carrier = "carrier"
        case privacy = "privacy"
        case abuse = "abuse"
        case domains = "domains"
    }
    public var getCountryName: String? {
        return context.getCountryName(country ?? "")
    }
    
    public var isEU: Bool? {
        return context.isEU(country ?? "")
    }
    
    public var getCountryFlag: CountryFlag? {
        return context.getCountryFlag(country ?? "")
    }
    
    public var getCountryFlagURL: String? {
        return context.getCountryFlagURL(country ?? "")
    }
    
    public var getCountryCurrency: CountryCurrency? {
        return context.getCountryCurrency(country ?? "")
    }
    
    public var getContinent: CountryContinent? {
        return context.getContinent(country ?? "")
    }
    
    public var getLatitude: String? {
        return loc?.components(separatedBy: ",")[safe: 0]
    }
    
    public var getLongitude: String? {
        return loc?.components(separatedBy: ",")[safe: 1]
    }
}
