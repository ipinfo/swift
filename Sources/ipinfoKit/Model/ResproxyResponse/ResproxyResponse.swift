//
//  ResproxyResponse.swift
//
//
//

import Foundation

public struct ResproxyResponse: Codable, Sendable {

    // MARK: Lifecycle

    public init(
        ip: String?,
        lastSeen: String?,
        percentDaysSeen: Double?,
        service: String?
    ) {
        self.ip = ip
        self.lastSeen = lastSeen
        self.percentDaysSeen = percentDaysSeen
        self.service = service
    }

    // MARK: Internal

    enum CodingKeys: String, CodingKey {
        case ip
        case lastSeen = "last_seen"
        case percentDaysSeen = "percent_days_seen"
        case service
    }

    public let ip: String?
    public let lastSeen: String?
    public let percentDaysSeen: Double?
    public let service: String?
}
