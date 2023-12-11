//
//  File.swift
//
//
//  Created by ahmed on 2023-04-09.
//

import Foundation

// Extension for IPINFO class
extension IPINFO {

    // Function to get ASN details
    public func getASNDetails(asn: String, completion: @escaping (_ status: Response,_ data: ASNResponse?,_ msg: String?) -> Void) {

        // Check if ASN details are cached
        if CachingManager.shared.getASNDataFromCache()[asn] == nil {

            // If not cached, make API request to fetch ASN details
            Service.shared.requestAPI(URL: .ASN(asn: asn), method: .get) { status, data, msg in
                switch status {
                case .success:
                    // If API request is successful, cache the response and save to local storage
                    do {
                        let response = try JSONDecoder().decode(ASNResponse.self, from: data)
                        CachingManager.shared.saveASNResult([asn:response])
                        completion(.success, response, nil)
                    } catch {
                        completion(.failure, nil, error.localizedDescription)
                    }
                case .failure:
                    // If API request fails, return failure status and empty data
                    completion(.failure, nil, msg)
                }
            }
        } else {
            // If ASN details are already cached, return cached data
            completion(.success, CachingManager.shared.getASNDataFromCache()[asn], "Success")
        }
    }
}
