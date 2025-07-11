//
//  IPResponse.swift
//
//
//

import Foundation

public struct IPResponse: Codable, Sendable {
    
    // MARK: Lifecycle
    
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
        domains: Domains?) {
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
    
    // MARK: Public
    
    public var getCountryName: String? {
        context.getCountryName(country ?? "")
    }
    
    public var isEU: Bool? {
        context.isEU(country ?? "")
    }
    
    @MainActor
    public var getCountryFlag: CountryFlag? {
        context.getCountryFlag(country ?? "")
    }
    
    public var getCountryFlagURL: String? {
        context.getCountryFlagURL(country ?? "")
    }
    
    @MainActor
    public var getCountryCurrency: CountryCurrency? {
        context.getCountryCurrency(country ?? "")
    }
    
    @MainActor
    public var getContinent: CountryContinent? {
        context.getContinent(country ?? "")
    }
    
    public var getLatitude: String? {
        loc?.components(separatedBy: ",")[safe: 0]
    }
    
    public var getLongitude: String? {
        loc?.components(separatedBy: ",")[safe: 1]
    }
    
    // MARK: Internal
    
    enum CodingKeys: String, CodingKey {
        case ip
        case hostname
        case bogon
        case anycast
        case city
        case region
        case country
        case loc
        case org
        case postal
        case timezone
        case asn
        case company
        case carrier
        case privacy
        case abuse
        case domains
    }
    
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
}
