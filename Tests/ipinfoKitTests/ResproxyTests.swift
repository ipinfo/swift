import Alamofire
import Foundation
import Testing
import ipinfoKit

/// Custom URLProtocol that only mocks specific URLs for resproxy tests
private class ResproxyMockURLProtocol: URLProtocol {
    nonisolated(unsafe) static var mockResponses: [String: Data] = [:]

    override class func canInit(with request: URLRequest) -> Bool {
        guard let url = request.url?.absoluteString else { return false }
        return mockResponses.keys.contains(url)
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        guard let url = request.url?.absoluteString,
              let data = ResproxyMockURLProtocol.mockResponses[url] else {
            client?.urlProtocol(self, didFailWithError: NSError(domain: "ResproxyMockURLProtocol", code: 404))
            return
        }

        let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: ["Content-Type": "application/json"])!
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: data)
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}

@MainActor
struct ResproxyTests {

    @Test func resproxyTest() async throws {
        // Set up mock response
        let mockData = """
            {"ip":"175.107.211.204","last_seen":"2025-01-20","percent_days_seen":0.85,"service":"example_service"}
            """.data(using: .utf8)!
        ResproxyMockURLProtocol.mockResponses["https://ipinfo.io/resproxy/175.107.211.204"] = mockData

        // Configure mock session for this test
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [ResproxyMockURLProtocol.self]
        let mockSession = Session(configuration: configuration)
        Service.shared.session = mockSession

        let response = try await withCheckedThrowingContinuation { continuation in
            IPINFO.shared.getResproxy(ip: "175.107.211.204") { status, response, msg in
                switch status {
                case .success:
                    if let response = response {
                        continuation.resume(returning: response)
                    } else {
                        continuation.resume(
                            throwing: NSError(
                                domain: "ResproxyTests", code: 1,
                                userInfo: [NSLocalizedDescriptionKey: "Response is nil"]))
                    }
                case .failure:
                    continuation.resume(
                        throwing: NSError(
                            domain: "ResproxyTests", code: 2,
                            userInfo: [NSLocalizedDescriptionKey: msg ?? "Unknown error"]))
                }
            }
        }

        Service.shared.session = nil
        ResproxyMockURLProtocol.mockResponses.removeAll()

        #expect(response.ip == "175.107.211.204")
        #expect(response.lastSeen == "2025-01-20")
        #expect(response.percentDaysSeen == 0.85)
        #expect(response.service == "example_service")
    }

    @Test func resproxyEmptyTest() async throws {
        // Set up mock response for empty result
        let mockData = "{}".data(using: .utf8)!
        ResproxyMockURLProtocol.mockResponses["https://ipinfo.io/resproxy/8.8.8.8"] = mockData

        // Configure mock session for this test
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [ResproxyMockURLProtocol.self]
        let mockSession = Session(configuration: configuration)
        Service.shared.session = mockSession

        let response = try await withCheckedThrowingContinuation { continuation in
            IPINFO.shared.getResproxy(ip: "8.8.8.8") { status, response, msg in
                switch status {
                case .success:
                    if let response = response {
                        continuation.resume(returning: response)
                    } else {
                        continuation.resume(
                            throwing: NSError(
                                domain: "ResproxyTests", code: 1,
                                userInfo: [NSLocalizedDescriptionKey: "Response is nil"]))
                    }
                case .failure:
                    continuation.resume(
                        throwing: NSError(
                            domain: "ResproxyTests", code: 2,
                            userInfo: [NSLocalizedDescriptionKey: msg ?? "Unknown error"]))
                }
            }
        }

        Service.shared.session = nil
        ResproxyMockURLProtocol.mockResponses.removeAll()

        #expect(response.ip == nil)
        #expect(response.lastSeen == nil)
        #expect(response.percentDaysSeen == nil)
        #expect(response.service == nil)
    }
}
