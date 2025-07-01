import ipinfoKit

import Foundation
import Testing

struct IPInfoLiteTests {
    @Test func liteCloudflareDNSTest() async throws {
      let client = IPInfoLite(token: ProcessInfo.processInfo.environment["IPInfoKitAccessToken"] ?? "")

      let response = try await client.lookup(ip: "1.1.1.1")

      #expect(
        response == IPInfoLite.Response(
          ip: "1.1.1.1",
          asn: "AS13335",
          asName: "Cloudflare, Inc.",
          asDomain: "cloudflare.com",
          countryCode: "AU",
          country: "Australia",
          continentCode: "OC",
          continent: "Oceania"
        )
      )
    }

  @Test func liteBogonTest() async throws {
    let client = IPInfoLite(token: ProcessInfo.processInfo.environment["IPInfoKitAccessToken"] ?? "")

    let response = try await client.lookup(ip: "192.168.1.1")

    #expect(
      response == IPInfoLite.Response(
        ip: "1.1.1.1",
        asn: "AS13335",
        asName: "Cloudflare, Inc.",
        asDomain: "cloudflare.com",
        countryCode: "AU",
        country: "Australia",
        continentCode: "OC",
        continent: "Oceania"
      )
    )
  }
}
