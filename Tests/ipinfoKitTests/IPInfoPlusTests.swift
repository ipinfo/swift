import ipinfoKit

import Foundation
import Testing

@MainActor
struct IPInfoPlusTests {
  @Test func plusGoogleDNSTest() async throws {
    let client = IPInfoPlus(token: ProcessInfo.processInfo.environment["IPInfoKitAccessToken"] ?? "")

    let response = try await client.lookup(ip: "8.8.8.8")

    guard case .ip(let ipResponse) = response else {
      Issue.record("Expected IP response, got bogon")
      return
    }

    // Test basic fields
    #expect(ipResponse.ip == "8.8.8.8")
    #expect(ipResponse.hostname != nil)

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
    #expect(ipResponse.geo.dmaCode != nil)
    #expect(ipResponse.geo.geonameId != nil)
    #expect(ipResponse.geo.radius != nil)
    #expect(ipResponse.geo.lastChanged == nil)

    // Test AS fields
    #expect(ipResponse.as.asn == "AS15169")
    #expect(!ipResponse.as.name.isEmpty)
    #expect(!ipResponse.as.domain.isEmpty)
    #expect(!ipResponse.as.type.isEmpty)
    #expect(ipResponse.as.lastChanged != nil)

    // Test network flags
    #expect(!ipResponse.isAnonymous)
    #expect(ipResponse.isAnycast)
    #expect(ipResponse.isHosting)
    #expect(!ipResponse.isMobile)
    #expect(!ipResponse.isSatellite)

    // Test anonymous object
    #expect(!ipResponse.anonymous.isProxy)
    #expect(!ipResponse.anonymous.isRelay)
    #expect(!ipResponse.anonymous.isTor)
    #expect(!ipResponse.anonymous.isVpn)

    // Test mobile object (can be empty for non-mobile IPs)
    #expect(ipResponse.mobile.name == nil)
    #expect(ipResponse.mobile.mcc == nil)
    #expect(ipResponse.mobile.mnc == nil)
  }

  @Test func plusBogonTest() async throws {
    let client = IPInfoPlus(token: ProcessInfo.processInfo.environment["IPInfoKitAccessToken"] ?? "")

    let response = try await client.lookup(ip: "192.168.1.1")

    #expect(response == .bogon(.init(ip: "192.168.1.1")))
  }

  @Test func plusNoIPTest() async throws {
    let client = IPInfoPlus(token: ProcessInfo.processInfo.environment["IPInfoKitAccessToken"] ?? "")

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
