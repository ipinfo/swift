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
    case isAnycast
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

  public init(from decoder: any Decoder) throws {
    let container: KeyedDecodingContainer<IPResponse.CodingKeys> = try decoder.container(keyedBy: IPResponse.CodingKeys.self)

    self.ip = try container.decodeIfPresent(String.self, forKey: IPResponse.CodingKeys.ip)
    self.hostname = try container.decodeIfPresent(String.self, forKey: IPResponse.CodingKeys.hostname)
    self.bogon = try container.decodeIfPresent(Bool.self, forKey: IPResponse.CodingKeys.bogon)
    self.anycast = try container
      .decodeIfPresent(Bool.self, forKey: IPResponse.CodingKeys.anycast) ?? container
      .decodeIfPresent(Bool.self, forKey: IPResponse.CodingKeys.isAnycast)
    self.city = try container.decodeIfPresent(String.self, forKey: IPResponse.CodingKeys.city)
    self.region = try container.decodeIfPresent(String.self, forKey: IPResponse.CodingKeys.region)
    self.country = try container.decodeIfPresent(String.self, forKey: IPResponse.CodingKeys.country)
    self.loc = try container.decodeIfPresent(String.self, forKey: IPResponse.CodingKeys.loc)
    self.org = try container.decodeIfPresent(String.self, forKey: IPResponse.CodingKeys.org)
    self.postal = try container.decodeIfPresent(String.self, forKey: IPResponse.CodingKeys.postal)
    self.timezone = try container.decodeIfPresent(String.self, forKey: IPResponse.CodingKeys.timezone)
    self.asn = try container.decodeIfPresent(ASN.self, forKey: IPResponse.CodingKeys.asn)
    self.company = try container.decodeIfPresent(Company.self, forKey: IPResponse.CodingKeys.company)
    self.carrier = try container.decodeIfPresent(Carrier.self, forKey: IPResponse.CodingKeys.carrier)
    self.privacy = try container.decodeIfPresent(Privacy.self, forKey: IPResponse.CodingKeys.privacy)
    self.abuse = try container.decodeIfPresent(Abuse.self, forKey: IPResponse.CodingKeys.abuse)
    self.domains = try container.decodeIfPresent(Domains.self, forKey: IPResponse.CodingKeys.domains)

  }

  public func encode(to encoder: any Encoder) throws {
    var container: KeyedEncodingContainer<IPResponse.CodingKeys> = encoder.container(keyedBy: IPResponse.CodingKeys.self)

    try container.encodeIfPresent(self.ip, forKey: IPResponse.CodingKeys.ip)
    try container.encodeIfPresent(self.hostname, forKey: IPResponse.CodingKeys.hostname)
    try container.encodeIfPresent(self.bogon, forKey: IPResponse.CodingKeys.bogon)
    try container.encodeIfPresent(self.anycast, forKey: IPResponse.CodingKeys.anycast)
    try container.encodeIfPresent(self.city, forKey: IPResponse.CodingKeys.city)
    try container.encodeIfPresent(self.region, forKey: IPResponse.CodingKeys.region)
    try container.encodeIfPresent(self.country, forKey: IPResponse.CodingKeys.country)
    try container.encodeIfPresent(self.loc, forKey: IPResponse.CodingKeys.loc)
    try container.encodeIfPresent(self.org, forKey: IPResponse.CodingKeys.org)
    try container.encodeIfPresent(self.postal, forKey: IPResponse.CodingKeys.postal)
    try container.encodeIfPresent(self.timezone, forKey: IPResponse.CodingKeys.timezone)
    try container.encodeIfPresent(self.asn, forKey: IPResponse.CodingKeys.asn)
    try container.encodeIfPresent(self.company, forKey: IPResponse.CodingKeys.company)
    try container.encodeIfPresent(self.carrier, forKey: IPResponse.CodingKeys.carrier)
    try container.encodeIfPresent(self.privacy, forKey: IPResponse.CodingKeys.privacy)
    try container.encodeIfPresent(self.abuse, forKey: IPResponse.CodingKeys.abuse)
    try container.encodeIfPresent(self.domains, forKey: IPResponse.CodingKeys.domains)
  }
}
