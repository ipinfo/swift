import Foundation

@available(iOS 13.0.0, macOS 10.15.0, *)
@MainActor
open class IPInfoCore {
  private let urlSession: URLSession
  private let jsonDecoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return decoder
  }()

  private var token: String

  public init(token: String, urlSession: URLSession = .shared) {
    self.token = token
    self.urlSession = urlSession
  }

  public func lookup(ip: String? = nil) async throws -> Response {
    let endpoint = ip ?? "me"
    var urlRequest = URLRequest(url: URL(string: "https://api.ipinfo.io/lookup/\(endpoint)")!)
    urlRequest.allHTTPHeaderFields = [
      "accept": "application/json",
      "authorization": "Bearer \(token)",
      "content-type": "application/json",
      "user-agent": "IPinfoClient/Swift/\(Constants.SDK_VERSION)",
    ]

    let (data, response) = try await urlSession.data(for: urlRequest)

    let httpResponse = response as! HTTPURLResponse
    guard (200..<300).contains(httpResponse.statusCode) else {
      throw IPInfoCore.Error.unacceptableStatusCode(httpResponse.statusCode)
    }

    return try jsonDecoder.decode(Response.self, from: data)
  }
}

@available(iOS 13.0.0, macOS 10.15.0, *)
extension IPInfoCore {
  public enum Response: Equatable, Decodable {
    private enum CodingKeys: CodingKey {
      case bogon
    }

    case ip(IPResponse)
    case bogon(BogonResponse)

    public init(from decoder: any Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      let isBogon = try container.decodeIfPresent(Bool.self, forKey: .bogon) ?? false

      if isBogon {
        self = .bogon(try BogonResponse(from: decoder))
      } else {
        self = .ip(try IPResponse(from: decoder))
      }
    }
  }

  public struct BogonResponse: Equatable, Decodable {
    public let ip: String

    public init(ip: String) {
      self.ip = ip
    }
  }

  public struct IPResponse: Equatable, Decodable {
    public let ip: String
    public let geo: Geo
    public let `as`: AS
    public let isAnonymous: Bool
    public let isAnycast: Bool
    public let isHosting: Bool
    public let isMobile: Bool
    public let isSatellite: Bool

    public init(
      ip: String,
      geo: Geo,
      as: AS,
      isAnonymous: Bool,
      isAnycast: Bool,
      isHosting: Bool,
      isMobile: Bool,
      isSatellite: Bool
    ) {
      self.ip = ip
      self.geo = geo
      self.`as` = `as`
      self.isAnonymous = isAnonymous
      self.isAnycast = isAnycast
      self.isHosting = isHosting
      self.isMobile = isMobile
      self.isSatellite = isSatellite
    }
  }

  public struct Geo: Equatable, Decodable {
    public let city: String
    public let region: String
    public let regionCode: String
    public let country: String
    public let countryCode: String
    public let continent: String
    public let continentCode: String
    public let latitude: Double
    public let longitude: Double
    public let timezone: String
    public let postalCode: String

    public init(
      city: String,
      region: String,
      regionCode: String,
      country: String,
      countryCode: String,
      continent: String,
      continentCode: String,
      latitude: Double,
      longitude: Double,
      timezone: String,
      postalCode: String
    ) {
      self.city = city
      self.region = region
      self.regionCode = regionCode
      self.country = country
      self.countryCode = countryCode
      self.continent = continent
      self.continentCode = continentCode
      self.latitude = latitude
      self.longitude = longitude
      self.timezone = timezone
      self.postalCode = postalCode
    }
  }

  public struct AS: Equatable, Decodable {
    public let asn: String
    public let name: String
    public let domain: String
    public let type: String

    public init(
      asn: String,
      name: String,
      domain: String,
      type: String
    ) {
      self.asn = asn
      self.name = name
      self.domain = domain
      self.type = type
    }
  }
}

@available(iOS 13.0.0, macOS 10.15.0, *)
extension IPInfoCore {
  public enum Error: Swift.Error, LocalizedError {
    case unacceptableStatusCode(Int)

    public var errorDescription: String? {
      switch self {
      case .unacceptableStatusCode(let statusCode):
        return "Response status code was unacceptable: \(statusCode)."
      }
    }
  }
}
