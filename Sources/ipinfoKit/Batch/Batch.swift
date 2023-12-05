//
//  File.swift
//
//
//  Created by ahmed on 2023-04-09.
//

import Foundation
extension IPINFO{
    public func getBatch(ipAddresses:  [String], withFilter: Bool, completion: @escaping (_ status: Response,_ data: [String: Any ]?,_ msg: String)->()){
        var result: [String: Any]
        var newIPs: [String] = [] // Array to store new IP addresses that are not present in the cache
        result = [String: Any]()
        // Loop through the input IP addresses and separate them into valid and bogon IP addresses
        for ipAddress in ipAddresses {
            
            if ipAddress.starts(with: "AS"){
                if CachingManager.shared.getASNDataFromCache()[ipAddress] == nil{
                    newIPs.append(ipAddress)
                }else{
                    result[ipAddress] = CachingManager.shared.getASNDataFromCache()[ipAddress]
                }
            }else if ipAddress.contains("/"){
                newIPs.append(ipAddress)
            }else if ipAddress.ipType == .IPv4{
                if isBogonIP(ipAddress){
                    result[ipAddress] = [
                        [
                            "bogon": true,
                            "ip": ipAddress
                        ]
                    ]
                }else{
                    if CachingManager.shared.getDataFromCache()[ipAddress] == nil {
                        newIPs.append(ipAddress)
                    } else {
                        result[ipAddress] = CachingManager.shared.getDataFromCache()[ipAddress]
                    }
                }
            }else if ipAddress.ipType == .IPv6{
                if CachingManager.shared.getDataFromCache()[ipAddress] == nil {
                    newIPs.append(ipAddress)
                }else{
                    result[ipAddress] = CachingManager.shared.getDataFromCache()[ipAddress]
                }
            }else{
                print("Invalid Data")
            }
            
        }
        
        // Serialize the new IP addresses into JSON data
        guard let jsonData = try? JSONSerialization.data(withJSONObject: newIPs, options: []) else {
            completion(.failure, nil, "Failed to serialize request body")
            return
        }
        // Set the request headers
        let headers = [
            "Authorization": "Bearer \(Constants.ACCESS_TOKEN)",
            "Content-Type": "application/json"
        ]
        // Create the URL request with appropriate method, headers, and body
        var request = URLRequest(url: URL(string: Service.Router.batch(withFilter: withFilter).endPoint)!)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = jsonData
        // Create a data task with the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle any error that occurred during the request
            if let error = error {
                completion(.failure, nil, error.localizedDescription)
                return
            }
            // Handle empty response data
            guard let data = data else {
                completion(.failure, nil, "Empty response data")
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] // Deserialize incoming data into a JSON dictionary
                for eachIP in newIPs {
                    
                    result[eachIP] = json?[eachIP] //as? [String: Any]
                    
                    if eachIP.starts(with: "AS"){
                        if let asnData = result[eachIP] as? ASNResponse{
                            CachingManager.shared.saveASNResult([eachIP: asnData])
                        }
                    }else if eachIP.ipType == .IPv4 || eachIP.ipType == .IPv6{
                        if let ipData = result[eachIP] as? IPResponse{
                            CachingManager.shared.saveResult([eachIP: ipData])
                        }
                    }
                }
            } catch {
                // Handle any errors that occur during JSON serialization/deserialization
                debugPrint("Failed to Save Bulk response in Cache")
                
            }
            
            completion(.success, result, "Success")
        }
        task.resume()
    }
}
extension String{
    var ipType: IPType {
        let ipv4Pattern = #"^(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)\.((25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)\.){2}(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)$"#
        
        let ipv6Pattern = #"^(([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9])?[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9])?[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9])?[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9])?[0-9]))$"#
        
        if let _ = self.range(of: ipv4Pattern, options: .regularExpression) {
            return .IPv4
        } else if let _ = self.range(of: ipv6Pattern, options: .regularExpression) {
            return .IPv6
        } else {
            return .none
        }
    }
}
enum IPType: Int{
    case IPv4 = 0, IPv6, none
}
