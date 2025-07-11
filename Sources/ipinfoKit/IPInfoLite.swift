import Foundation

@available(iOS 13.0.0, macOS 10.15.0, *)
@MainActor
open class IPInfoLite {
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

  public func lookup(ip: String) async throws -> Response {
    var urlRequest = URLRequest(url: URL(string: "https://api.ipinfo.io/lite/\(ip)")!)
    urlRequest.allHTTPHeaderFields = [
      "accept": "application/json",
      "authorization": "Bearer \(token)",
      "content-type": "application/json",
    ]

    let (data, response) = try await urlSession.data(for: urlRequest)

    let httpResponse = response as! HTTPURLResponse
    guard (200..<300).contains(httpResponse.statusCode) else {
      throw IPInfoLite.Error.unacceptableStatusCode(httpResponse.statusCode)
    }

    return try jsonDecoder.decode(Response.self, from: data)
  }
}

@available(iOS 13.0.0, macOS 10.15.0, *)
extension IPInfoLite {
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
    public let asn: String
    public let asName: String
    public let asDomain: String
    public let countryCode: String
    public let country: String
    public let continentCode: String
    public let continent: String

    public init(
      ip: String,
      asn: String,
      asName: String,
      asDomain: String,
      countryCode: String,
      country: String,
      continentCode: String,
      continent: String
    ) {
      self.ip = ip
      self.asn = asn
      self.asName = asName
      self.asDomain = asDomain
      self.countryCode = countryCode
      self.country = country
      self.continentCode = continentCode
      self.continent = continent
    }
  }
}

@available(iOS 13.0.0, macOS 10.15.0, *)
extension IPInfoLite {
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
