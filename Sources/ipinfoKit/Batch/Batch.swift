//
//  File.swift
//  
//
//  Created by ahmed on 2023-04-09.
//

import Foundation
extension IPINFO{
    public func getBatch(ipAddresses:  [String], withFilter: Bool, completion: @escaping (_ status: Response,_ data: Data,_ msg: String)->()) {
        
        var bogonIPs: [String] = [] // Array to store invalid/bogon IP addresses
        var validIPs: [String] = [] // Array to store valid IP addresses
        var newIPs: [String] = [] // Array to store new IP addresses that are not present in the cache
        var oldIPs: [String] = [] // Array to store old IP addresses that are present in the cache
        
        // Loop through the input IP addresses and separate them into valid and bogon IP addresses
        for ipAddress in ipAddresses {
            if isBogonIP(ipAddress) {
                bogonIPs.append(ipAddress)
            } else {
                validIPs.append(ipAddress)
            }
        }
        
        // If there are bogon IP addresses, print a message indicating that they are skipped
        if bogonIPs.count > 0 {
            print("Skipping bogon IPs: \(bogonIPs)")
        }
        // Loop through the valid IP addresses and separate them into new and old IP addresses based on their presence in the cache
        for eachValidIP in validIPs{
            if Global.shared.Cache[eachValidIP] == nil{
                newIPs.append(eachValidIP)
            }else{
                oldIPs.append(eachValidIP)
            }
        }
        
        // Serialize the new IP addresses into JSON data
        guard let jsonData = try? JSONSerialization.data(withJSONObject: newIPs, options: []) else {
            completion(.failure, Data(), "Failed to serialize request body")
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
                completion(.failure, Data(), error.localizedDescription)
                return
            }
            
            // Handle empty response data
            guard let data = data else {
                completion(.failure, Data(), "Empty response data")
                return
            }
            
            
            do {
                var json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] // Deserialize incoming data into a JSON dictionary
                
                for eachIP in newIPs {
                    if let ipAddress = json?[eachIP] as? [String: Any] {
                        let ipAddressData = try JSONSerialization.data(withJSONObject: ipAddress, options: []) // Serialize the IP address data into JSON data
                        Global.shared.Cache[eachIP] = ipAddressData // Store the IP address data into a shared cache
                        self.saveResult(Global.shared.Cache) // Save the updated cache
                    }
                }
                
                for eachIP in oldIPs {
                    if oldIPs.count == 0 {
                        return // Return early if there are no old IP addresses to process
                    }
                    json?[eachIP] = try JSONSerialization.jsonObject(with: Global.shared.Cache[eachIP] ?? Data(), options: []) as? [String: Any] // Deserialize cached data and update the JSON dictionary with it
                }
                
                let ipAddressData = try JSONSerialization.data(withJSONObject: json ?? [String: Any](), options: []) // Serialize the updated JSON dictionary into data
                completion(.success, ipAddressData, "Success") // Call the completion handler with success status and the updated data
            } catch {
                debugPrint("Failed to Save Bulk response in Cache") // Handle any errors that occur during JSON serialization/deserialization
            }

            
            
            completion(.success, data, "Success")
            
        }
        task.resume()
    }
    
}
