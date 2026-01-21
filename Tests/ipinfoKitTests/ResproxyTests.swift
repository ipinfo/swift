import Foundation
import Testing
import ipinfoKit

@MainActor
struct ResproxyTests {
    @Test func resproxyTest() async throws {
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

        #expect(response.ip == "175.107.211.204")
        #expect(response.lastSeen != nil)
        #expect(response.percentDaysSeen != nil)
        #expect(response.service != nil)
    }

    @Test func resproxyEmptyTest() async throws {
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

        #expect(response.ip == nil)
        #expect(response.lastSeen == nil)
        #expect(response.percentDaysSeen == nil)
        #expect(response.service == nil)
    }
}
