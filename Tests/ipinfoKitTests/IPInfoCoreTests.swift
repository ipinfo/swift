import ipinfoKit

import Foundation
import Testing

@MainActor
struct IPInfoCoreTests {
  @Test func coreGoogleDNSTest() async throws {
    let client = IPInfoCore(token: ProcessInfo.processInfo.environment["IPInfoKitAccessToken"] ?? "")

    let response = try await client.lookup(ip: "8.8.8.8")

    guard case .ip(let ipResponse) = response else {
      Issue.record("Expected IP response, got bogon")
      return
    }

    // Test basic fields
    #expect(ipResponse.ip == "8.8.8.8")

    // Test geo fields
    #expect(!ipResponse.geo.city.isEmpty)
    #expect(!ipResponse.geo.region.isEmpty)
    #expect(!ipResponse.geo.regionCode.isEmpty)
    #expect(!ipResponse.geo.country.isEmpty)
    #expect(!ipResponse.geo.countryCode.isEmpty)
    #expect(!ipResponse.geo.continent.isEmpty)
    #expect(!ipResponse.geo.continentCode.isEmpty)
    #expect(ipResponse.geo.latitude != 0.0)
    #expect(ipResponse.geo.longitude != 0.0)
    #expect(!ipResponse.geo.timezone.isEmpty)
    #expect(!ipResponse.geo.postalCode.isEmpty)

    // Test AS fields
    #expect(ipResponse.as.asn == "AS15169")
    #expect(!ipResponse.as.name.isEmpty)
    #expect(!ipResponse.as.domain.isEmpty)
    #expect(!ipResponse.as.type.isEmpty)

    // Test network flags
    #expect(!ipResponse.isAnonymous)
    #expect(ipResponse.isAnycast)
    #expect(ipResponse.isHosting)
    #expect(!ipResponse.isMobile)
    #expect(!ipResponse.isSatellite)
  }

  @Test func coreBogonTest() async throws {
    let client = IPInfoCore(token: ProcessInfo.processInfo.environment["IPInfoKitAccessToken"] ?? "")

    let response = try await client.lookup(ip: "192.168.1.1")

    #expect(response == .bogon(.init(ip: "192.168.1.1")))
  }

  @Test func coreNoIPTest() async throws {
    let client = IPInfoCore(token: ProcessInfo.processInfo.environment["IPInfoKitAccessToken"] ?? "")

    let response = try await client.lookup()

    guard case .ip(let ipResponse) = response else {
      Issue.record("Expected IP response, got bogon")
      return
    }

    // Should return details for the caller's IP
    #expect(ipResponse.ip != "")
    #expect(!ipResponse.geo.country.isEmpty)
  }
}
