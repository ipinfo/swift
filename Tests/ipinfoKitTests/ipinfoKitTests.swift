import XCTest
@testable import ipinfoKit

final class ipinfoKitTests: XCTestCase {
    func testIPResponseInitialization() {
        let expectation = self.expectation(description: "IP details request")
        
        IPINFO.shared.getDetails(ip: "8.8.8.8") { status, response, msg in
            switch status {
            case .success:
                XCTAssertNotNil(response)
                guard let response else { return }
                XCTAssertNotNil(response, "Response is nil")
                XCTAssertEqual(response.ip, "8.8.8.8")
                XCTAssertEqual(response.hostname, "dns.google")
                XCTAssertTrue(response.anycast ?? false)
                XCTAssertEqual(response.city, "Mountain View")
                XCTAssertEqual(response.region, "California")
                XCTAssertEqual(response.country, "US")
                XCTAssertEqual(response.getCountryName, "United States")
                XCTAssertFalse(response.isEU ?? true)
                XCTAssertEqual(response.getCountryFlag?.emoji, "🇺🇸")
                XCTAssertEqual(response.getCountryFlag?.unicode, "U+1F1FA U+1F1F8")
                XCTAssertEqual(response.getCountryFlagURL, "https://cdn.ipinfo.io/static/images/countries-flags/US.svg")
                XCTAssertEqual(response.getCountryCurrency?.code, "USD")
                XCTAssertEqual(response.getCountryCurrency?.symbol, "$")
                XCTAssertEqual(response.getContinent?.code, "NA")
                XCTAssertEqual(response.getContinent?.name, "North America")
                XCTAssertEqual(response.timezone, "America/Los_Angeles")
                XCTAssertFalse(response.privacy?.proxy ?? true)
                XCTAssertFalse(response.privacy?.vpn ?? true)
                XCTAssertFalse(response.privacy?.tor ?? true)
                XCTAssertFalse(response.privacy?.relay ?? true)
                XCTAssertTrue(response.privacy?.hosting ?? false)
                XCTAssertEqual(response.privacy?.service, "")
                XCTAssertEqual(response.domains?.domains.count, 5)
            case .failure:
                XCTFail(msg ?? "Error")
            }
            
            expectation.fulfill()
        }
        // Wait for the asynchronous call to complete (timeout after 5 seconds)
        waitForExpectations(timeout: 5, handler: nil)
    }
    func testBogonIPv4() {
        let expectation = self.expectation(description: "Bogon IP request")
        IPINFO.shared.getDetails(ip: "0.0.0.0") { status, response, msg in
            switch status {
            case .success:
                XCTAssertNotNil(response)
                XCTAssertNotNil(response, "Response is nil")
                XCTAssertEqual(response?.ip, "0.0.0.0")
                XCTAssertTrue(response?.bogon ?? false)
            case .failure:
                XCTAssertNil(response)
                XCTAssertEqual(msg, "IP is Bogon")
            }
            expectation.fulfill()
        }
        // Wait for the asynchronous call to complete (timeout after 5 seconds)
        waitForExpectations(timeout: 5, handler: nil)
    }
    func testBogonIPv6() {
        let expectation = self.expectation(description: "Bogon IP request")
        IPINFO.shared.getDetails(ip: "2001:0:c000:200::0:255:1") { status, response, msg in
            switch status {
            case .success:
                XCTAssertNotNil(response)
                XCTAssertNotNil(response, "Response is nil")
                XCTAssertEqual(response?.ip, "2001:0:c000:200::0:255:1")
                XCTAssertTrue(response?.bogon ?? false)
            case .failure:
                XCTAssertNil(response)
                XCTAssertEqual(msg, "IP is Bogon")
            }
            expectation.fulfill()
        }
        // Wait for the asynchronous call to complete (timeout after 5 seconds)
        waitForExpectations(timeout: 5, handler: nil)
    }
    func testASNDetails() {
        let expectation = self.expectation(description: "IP details request")
        
        IPINFO.shared.getASNDetails(asn: "AS123") { status, response, msg in
            switch status {
            case .success:
                XCTAssertNotNil(response)
                guard let response else { return }
                XCTAssertNotNil(response, "Response is nil")
                XCTAssertEqual(response.asn, "AS123")
                XCTAssertEqual(response.name, "Air Force Systems Networking")
                XCTAssertEqual(response.country, "US")
                XCTAssertEqual(response.countryName, "United States")
                XCTAssertEqual(response.allocated, "1987-08-24")
                XCTAssertEqual(response.registry, "arin")
                XCTAssertEqual(response.domain, "af.mil")
                XCTAssertEqual(response.numIPS, 0)
                XCTAssertEqual(response.type, "inactive")
            case .failure:
                XCTFail(msg ?? "Error")
            }
            
            expectation.fulfill()
        }
        // Wait for the asynchronous call to complete (timeout after 5 seconds)
        waitForExpectations(timeout: 5, handler: nil)
    }
    func testGetBash() {
        let expectation = self.expectation(description: "IP details request")
        IPINFO.shared.getBatch(ipAddresses: ["AS123", "8.8.8.8", "9.9.9.9/hostname", "2001:0:c000:200::0:255:1", "0.0.0.0"], withFilter: false) { status, response, msg in
            switch status {
            case .success:
                guard let response else { return }
                XCTAssertEqual(response.keys.contains("AS123"), true)
                XCTAssertEqual(response.keys.contains("8.8.8.8"), true)
                XCTAssertEqual(response.keys.contains("9.9.9.9/hostname"), true)
                XCTAssertEqual(response.keys.contains("2001:0:c000:200::0:255:1"), true)
                XCTAssertEqual(response.keys.contains("0.0.0.0"), true)
                
                if let ansResponse = response["AS123"] as? ASNResponse{
                    XCTAssertNotNil(ansResponse)
                    XCTAssertNotNil(ansResponse, "Response is nil")
                    XCTAssertEqual(ansResponse.asn, "AS123")
                    XCTAssertEqual(ansResponse.name, "Air Force Systems Networking")
                    XCTAssertEqual(ansResponse.country, "US")
                    XCTAssertEqual(ansResponse.countryName, "United States")
                    XCTAssertEqual(ansResponse.allocated, "1987-08-24")
                    XCTAssertEqual(ansResponse.registry, "arin")
                    XCTAssertEqual(ansResponse.domain, "af.mil")
                    XCTAssertEqual(ansResponse.numIPS, 0)
                    XCTAssertEqual(ansResponse.type, "inactive")
                }
                
                if let ipResponse = response["8.8.8.8"] as? IPResponse{
                    XCTAssertNotNil(ipResponse)
                    XCTAssertNotNil(ipResponse, "Response is nil")
                    XCTAssertEqual(ipResponse.ip, "8.8.8.8")
                    XCTAssertEqual(ipResponse.hostname, "dns.google")
                    XCTAssertTrue(ipResponse.anycast ?? false)
                    XCTAssertEqual(ipResponse.city, "Mountain View")
                    XCTAssertEqual(ipResponse.region, "California")
                    XCTAssertEqual(ipResponse.country, "US")
                    XCTAssertEqual(ipResponse.getCountryName, "United States")
                    XCTAssertFalse(ipResponse.isEU ?? true)
                    XCTAssertEqual(ipResponse.getCountryFlag?.emoji, "🇺🇸")
                    XCTAssertEqual(ipResponse.getCountryFlag?.unicode, "U+1F1FA U+1F1F8")
                    XCTAssertEqual(ipResponse.getCountryFlagURL, "https://cdn.ipinfo.io/static/images/countries-flags/US.svg")
                    XCTAssertEqual(ipResponse.getCountryCurrency?.code, "USD")
                    XCTAssertEqual(ipResponse.getCountryCurrency?.symbol, "$")
                    XCTAssertEqual(ipResponse.getContinent?.code, "NA")
                    XCTAssertEqual(ipResponse.getContinent?.name, "North America")
                    XCTAssertEqual(ipResponse.timezone, "America/Los_Angeles")
                    XCTAssertFalse(ipResponse.privacy?.proxy ?? true)
                    XCTAssertFalse(ipResponse.privacy?.vpn ?? true)
                    XCTAssertFalse(ipResponse.privacy?.tor ?? true)
                    XCTAssertFalse(ipResponse.privacy?.relay ?? true)
                    XCTAssertTrue(ipResponse.privacy?.hosting ?? false)
                    XCTAssertEqual(ipResponse.privacy?.service, "")
                    XCTAssertEqual(ipResponse.domains?.domains.count, 5)
                }
                
                if let ipHostname = response["9.9.9.9/hostname"] as? String{
                    XCTAssertEqual(ipHostname,"dns9.quad9.net")
                }
                
                if let batchIPV4 = response["0.0.0.0"] as? IPResponse{
                    XCTAssertEqual(batchIPV4.ip,"0.0.0.0")
                    XCTAssertEqual(batchIPV4.bogon, true)
                    XCTAssertTrue(batchIPV4.bogon ?? false)
                }
                if let batchIPV6 = response["2001:0:c000:200::0:255:1"] as? IPResponse{
                    XCTAssertEqual(batchIPV6.ip,"2001:0:c000:200::0:255:1")
                    XCTAssertEqual(batchIPV6.bogon, true)
                    XCTAssertTrue(batchIPV6.bogon ?? false)
                }
            case .failure:
                XCTFail("Error Batch")
            }
            
            
            expectation.fulfill()
        }
        // Wait for the asynchronous call to complete (timeout after 5 seconds)
        waitForExpectations(timeout: 5, handler: nil)
    }
}
