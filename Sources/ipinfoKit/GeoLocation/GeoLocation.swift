//
//  File.swift
//
//
//

import Foundation
extension IPINFO {
    public func getDetails(ip: String, completion: @escaping (_ status: Response,_ data: IPResponse?,_ msg: String?) -> Void) {

        // Check if IP is BOGON
        if isBogonIP(ip), ip.ipType == .IPv4 {
            completion(
                .failure,
                nil,
                "IP is Bogon") // Call the completion handler with failure status and empty data, indicating that the IP is a BOGON IP
        } else {
            if CachingManager.shared.getDataFromCache()[ip] == nil { // Check if the IP data is present in the cache
                Service.shared.requestAPI(URL: .geoLocation(ipAddress: ip), method: .get) { status, data, msg in
                    // If IP data is not present in cache, make API request to fetch geo-location data
                    switch status {
                    case .success:
                        do {
                            var decoder = JSONDecoder()
                            decoder.keyDecodingStrategy = .convertFromSnakeCase
                            let response = try decoder.decode(IPResponse.self, from: data)
                            if response.bogon ?? false {
                                completion(.failure, nil, "IP is Bogon")
                            } else {
                                CachingManager.shared.saveResult([ip: response])
                                completion(.success, response, nil)
                            }
                        } catch {
                            completion(.failure, nil, error.localizedDescription)
                        }
                    case .failure:
                        completion(
                            .failure,
                            nil,
                            msg) // Call the completion handler with failure status and empty data, indicating that API request failed
                    }
                }
            } else {
                completion(
                    .success,
                    CachingManager.shared.getDataFromCache()[ip],
                    "Success") // If IP data is present in cache, call the completion handler with success status and the cached data
            }
        }
    }
}
