import ipinfoKit

import Foundation
import Testing

@MainActor
struct IPInfoLiteTests {
    @Test func liteCloudflareDNSTest() async throws {
      let client = IPInfoLite(token: ProcessInfo.processInfo.environment["IPInfoKitAccessToken"] ?? "")

      let response = try await client.lookup(ip: "1.1.1.1")

      let info = try #require({
        if case let .ip(info) = response { return info }
        Issue.record("Expected .ip, got \(response)")
        return nil
      }())

      #expect(info.ip ==  "1.1.1.1")
      #expect(info.asn == "AS13335")
      #expect(info.asName == "Cloudflare, Inc.")
      #expect(info.asDomain == "cloudflare.com")
      #expect(info.countryCode != "")
      #expect(info.country != "")
      #expect(info.continentCode != "")
      #expect(info.continent != "")
    }

  @Test func liteBogonTest() async throws {
    let client = IPInfoLite(token: ProcessInfo.processInfo.environment["IPInfoKitAccessToken"] ?? "")

    let response = try await client.lookup(ip: "192.168.1.1")

    #expect(response == .bogon(.init(ip: "192.168.1.1")))
  }
}
