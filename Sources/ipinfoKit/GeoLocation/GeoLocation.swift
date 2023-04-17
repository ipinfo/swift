//
//  File.swift
//  
//
//  Created by ahmed on 2023-04-09.
//

import Foundation
extension IPINFO {
    public func getDetails(ip: String, completion: @escaping (_ status: Response,_ data: Data,_ msg: String)->()) {
        // Check if IP is BOGON
        if isBogonIP(ip) {
            completion(.failure, Data(), "IP is Bogon") // Call the completion handler with failure status and empty data, indicating that the IP is a BOGON IP
        } else {
            if Global.shared.Cache[ip] == Data() || Global.shared.Cache[ip] == nil { // Check if the IP data is present in the cache
                Service.shared.requestAPI(URL: .geoLocation(ipAddress: ip), method: .get) { status, data, msg in
                    // If IP data is not present in cache, make API request to fetch geo-location data
                    switch status {
                    case .success:
                        Global.shared.Cache[ip] = data // Store the fetched IP data into the cache
                        self.saveResult(Global.shared.Cache) // Save the updated cache
                        completion(.success, data, msg) // Call the completion handler with success status and the fetched data
                    case .failure:
                        completion(.failure, Data(), msg) // Call the completion handler with failure status and empty data, indicating that API request failed
                    }
                }
            } else {
                completion(.success, Global.shared.Cache[ip] ?? Data(), "Success") // If IP data is present in cache, call the completion handler with success status and the cached data
            }
        }
    }
}
