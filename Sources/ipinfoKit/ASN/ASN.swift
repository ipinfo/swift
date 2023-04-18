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
    public func getASNDetails(asn: String, completion: @escaping (_ status: Response,_ data: Data,_ msg: String)->()) {
        
        // Check if ASN details are cached
        if Global.shared.Cache[asn] == nil {
            
            // If not cached, make API request to fetch ASN details
            Service.shared.requestAPI(URL: .ASN(asn: asn), method: .get) { status, data, msg in
                switch status {
                case .success:
                    // If API request is successful, cache the response and save to local storage
                    Global.shared.Cache[asn] = data
                    self.saveResult(Global.shared.Cache)
                    completion(.success, data, msg)
                case .failure:
                    // If API request fails, return failure status and empty data
                    completion(.failure, Data(), msg)
                }
            }
        } else {
            // If ASN details are already cached, return cached data
            completion(.success, Global.shared.Cache[asn] ?? Data(), "Success")
        }
    }
}
