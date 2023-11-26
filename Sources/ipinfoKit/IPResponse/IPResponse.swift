//
//  IPResponse.swift
//
//
//  Created by mslm on 22/11/2023.
//

import Foundation

public class IPResponse: Codable {
    public let ip: String
    public let hostname: String?
    public let bogon: Bool?
    public let anycast: Bool?
    public let city: String?
    public let region: String?
    public let country: String?
    public let loc: String?
    public let org: String?
    public let postal: String?
    public let timezone: String?
    public let asn: ASN?
    public let company: Company?
    public let carrier: Carrier?
    public let privacy: Privacy?
    public let abuse: Abuse?
    public let domains: Domains?
    public var context: CountryData? = CountryData()

    public init(
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

    public convenience init(ip: String, bogon: Bool) {
        self.init(
            ip: ip,
            hostname: nil,
            bogon: bogon,
            anycast: false,
            city: nil,
            region: nil,
            country: nil,
            loc: nil,
            org: nil,
            postal: nil,
            timezone: nil,
            asn: nil,
            company: nil,
            carrier: nil,
            privacy: nil,
            abuse: nil,
            domains: nil
        )
    }

    public func setContext(_ context: CountryData) {
        self.context = context
    }

    public func getCountryName() -> String? {
        return context?.getCountryName(country ?? "")
    }

    public func isEU() -> Bool? {
        return context?.isEU(country ?? "")
    }

    public func getCountryFlag() -> CountryFlag? {
        return context?.getCountryFlag(country ?? "")
    }

    public func getCountryFlagURL() -> String? {
        return context?.getCountryFlagURL(country ?? "")
    }

    public func getCountryCurrency() -> CountryCurrency? {
        return context?.getCountryCurrency(country ?? "")
    }

    public func getContinent() -> CountryContinent? {
        return context?.getContinent(country ?? "")
    }

    public func getLocation() -> String? {
        return loc
    }

    public func getLatitude() -> String? {
        return loc?.components(separatedBy: ",")[safe: 0]
    }

    public func getLongitude() -> String? {
        return loc?.components(separatedBy: ",")[safe: 1]
    }

    public func getOrg() -> String? {
        return org
    }

    public func getPostal() -> String? {
        return postal
    }

    public func getTimezone() -> String? {
        return timezone
    }

    public func getAsn() -> ASN? {
        return asn
    }

    public func getCompany() -> Company? {
        return company
    }

    public func getCarrier() -> Carrier? {
        return carrier
    }

    public func getPrivacy() -> Privacy? {
        return privacy
    }

    public func getAbuse() -> Abuse? {
        return abuse
    }

    public func getDomains() -> Domains? {
        return domains
    }

    public var description: String {
        return bogon ?? false ?
            "IPResponse{ip='\(ip)', bogon='\(bogon ?? false)'}" :
        "IPResponse{ip='\(ip)', hostname='\(hostname ?? "")', anycast=\(anycast ?? false), city='\(city ?? "")', region='\(region ?? "")', country='\(country ?? "")', loc='\(loc ?? "")', org='\(org ?? "")', postal='\(postal ?? "")', timezone='\(timezone ?? "")', asn=\(asn?.description ?? ""), company=\(company?.description ?? ""), carrier=\(carrier?.description ?? ""), privacy=\(privacy?.description ?? ""), abuse=\(abuse?.description ?? ""), domains=\(domains?.description ?? "")}"
    }
}

extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
