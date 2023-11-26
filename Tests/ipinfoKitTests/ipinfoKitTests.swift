import XCTest
@testable import ipinfoKit

final class ipinfoKitTests: XCTestCase {
    func testIPResponseInitialization() {
        UserDefaults.standard.removeObject(forKey: UserDefaultKey.saveResultKey)
        let expectation = self.expectation(description: "IP details request")
        
        IPINFO.shared.getDetails(ip: "8.8.8.8") { status, data, msg in
            switch status {
            case .success:
                XCTAssertNotNil(data)
                do {
                    let response = try JSONDecoder().decode(IPResponse.self, from: data)
                    print(response)
                    XCTAssertNotNil(response, "Response is nil")
                    response.setContext(response.context ?? CountryData())
                    XCTAssertEqual(response.ip, "8.8.8.8")
                    XCTAssertEqual(response.hostname, "dns.google")
                    XCTAssertTrue(response.anycast ?? false)
                    XCTAssertEqual(response.city, "Mountain View")
                    XCTAssertEqual(response.region, "California")
                    XCTAssertEqual(response.country, "US")
                    XCTAssertEqual(response.getCountryName(), "United States")
                    XCTAssertFalse(response.isEU() ?? true)
                    XCTAssertEqual(response.getCountryFlag()?.emoji, "🇺🇸")
                    XCTAssertEqual(response.getCountryFlag()?.unicode, "U+1F1FA U+1F1F8")
                    XCTAssertEqual(response.getCountryFlagURL(), "https://cdn.ipinfo.io/static/images/countries-flags/US.svg")
                    XCTAssertEqual(response.getCountryCurrency()?.code, "USD")
                    XCTAssertEqual(response.getCountryCurrency()?.symbol, "$")
                    XCTAssertEqual(response.getContinent()?.code, "NA")
                    XCTAssertEqual(response.getContinent()?.name, "North America")
                    XCTAssertEqual(response.timezone, "America/Los_Angeles")
                    XCTAssertFalse(response.privacy?.proxy ?? true)
                    XCTAssertFalse(response.privacy?.vpn ?? true)
                    XCTAssertFalse(response.privacy?.tor ?? true)
                    XCTAssertFalse(response.privacy?.relay ?? true)
                    XCTAssertTrue(response.privacy?.hosting ?? false)
                    XCTAssertEqual(response.privacy?.service, "")
                    XCTAssertEqual(response.domains?.domains.count, 5)
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            case .failure:
                XCTFail(msg)
            }
            
            expectation.fulfill()
        }
        
        // Wait for the asynchronous call to complete (timeout after 5 seconds)
        waitForExpectations(timeout: 15, handler: nil)
    }
    func testBogonIP() {
        UserDefaults.standard.removeObject(forKey: UserDefaultKey.saveResultKey)
        let expectation = self.expectation(description: "Bogon IP request")
        IPINFO.shared.getDetails(ip: "0.0.0.0") { status, data, msg in
            switch status {
            case .success:
                XCTAssertNotNil(data)
                do {
                    let response = try JSONDecoder().decode(IPResponse.self, from: data)
                    print(response)
                    XCTAssertNotNil(response, "Response is nil")
                    response.setContext(response.context ?? CountryData())
                    XCTAssertEqual(response.ip, "0.0.0.0")
                    XCTAssertTrue(response.bogon ?? false)
                } catch {
                    print(error.localizedDescription)
                }
            case .failure:
                XCTAssertEqual(data, Data())
                XCTAssertEqual(msg, "IP is Bogon")
            }
            expectation.fulfill()
        }
        // Wait for the asynchronous call to complete (timeout after 5 seconds)
        waitForExpectations(timeout: 5, handler: nil)
        
    }
    
    func testIPLookup() {
        UserDefaults.standard.removeObject(forKey: UserDefaultKey.saveResultKey)
        let expectation = self.expectation(description: "IP details request")
        
        IPINFO.shared.lookupIP(ip: "8.8.8.8") { status, response, msg in
            switch status {
            case .success:
                XCTAssertNotNil(response)
                print(response ?? IPResponse(ip: "", bogon: false))
                XCTAssertNotNil(response, "Response is nil")
                response?.setContext(response?.context ?? CountryData())
                XCTAssertEqual(response?.ip, "8.8.8.8")
                XCTAssertEqual(response?.hostname, "dns.google")
                XCTAssertTrue(response?.anycast ?? false)
                XCTAssertEqual(response?.city, "Mountain View")
                XCTAssertEqual(response?.region, "California")
                XCTAssertEqual(response?.country, "US")
                XCTAssertEqual(response?.getCountryName(), "United States")
                XCTAssertFalse(response?.isEU() ?? true)
                XCTAssertEqual(response?.getCountryFlag()?.emoji, "🇺🇸")
                XCTAssertEqual(response?.getCountryFlag()?.unicode, "U+1F1FA U+1F1F8")
                XCTAssertEqual(response?.getCountryFlagURL(), "https://cdn.ipinfo.io/static/images/countries-flags/US.svg")
                XCTAssertEqual(response?.getCountryCurrency()?.code, "USD")
                XCTAssertEqual(response?.getCountryCurrency()?.symbol, "$")
                XCTAssertEqual(response?.getContinent()?.code, "NA")
                XCTAssertEqual(response?.getContinent()?.name, "North America")
                XCTAssertEqual(response?.timezone, "America/Los_Angeles")
                XCTAssertFalse(response?.privacy?.proxy ?? true)
                XCTAssertFalse(response?.privacy?.vpn ?? true)
                XCTAssertFalse(response?.privacy?.tor ?? true)
                XCTAssertFalse(response?.privacy?.relay ?? true)
                XCTAssertTrue(response?.privacy?.hosting ?? false)
                XCTAssertEqual(response?.privacy?.service, "")
                XCTAssertEqual(response?.domains?.domains.count, 5)
            case .failure:
                XCTFail(msg ?? "")
            }
            
            expectation.fulfill()
        }
        
        // Wait for the asynchronous call to complete (timeout after 5 seconds)
        waitForExpectations(timeout: 15, handler: nil)
    }
}


