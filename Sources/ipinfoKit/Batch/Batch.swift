//
//  File.swift
//
//
//  Created by ahmed on 2023-04-09.
//

import Foundation

extension IPINFO {

	// MARK: Public

	public func getBatch(
		ipAddresses: [String],
		withFilter _: Bool,
		completion: @escaping (_ status: Response,_ data: [String: Any]?,_ msg: String) -> Void) {
		var result: [String: Any]
		var newIPs: [String] = []
		var minbatchSize = Int()
		let group = DispatchGroup()
		let batchMaxSize = 1000
        
		result = [String: Any]()
		// Loop through the input IP addresses and separate them into valid and bogon IP addresses
		for ipAddress in ipAddresses {
            
			if ipAddress.starts(with: "AS") {
				if CachingManager.shared.getASNDataFromCache()[ipAddress] == nil {
					newIPs.append(ipAddress)
				} else {
					result[ipAddress] = CachingManager.shared.getASNDataFromCache()[ipAddress]
				}
			} else if ipAddress.contains("/") {
				newIPs.append(ipAddress)
			} else if ipAddress.ipType == .IPv4 {
				if isBogonIP(ipAddress) {
					result[ipAddress] = [
						[
							"bogon": true,
							"ip": ipAddress,
						],
					]
				} else {
					if CachingManager.shared.getDataFromCache()[ipAddress] == nil {
						newIPs.append(ipAddress)
					} else {
						result[ipAddress] = CachingManager.shared.getDataFromCache()[ipAddress]
					}
				}
			} else if ipAddress.ipType == .IPv6 {
				if CachingManager.shared.getDataFromCache()[ipAddress] == nil {
					newIPs.append(ipAddress)
				} else {
					result[ipAddress] = CachingManager.shared.getDataFromCache()[ipAddress]
				}
			}
		}
        
		if newIPs.count > batchMaxSize {
			minbatchSize = batchMaxSize
		} else {
			minbatchSize = newIPs.count
		}
        
		var batches = [[String]]()
		while !newIPs.isEmpty {
			let batchSize = min(newIPs.count, minbatchSize)
			let batch = Array(newIPs.prefix(batchSize))
			batches.append(batch)
			newIPs.removeSubrange(0..<batchSize)
		}
        
		for eachBatch in batches {
			group.enter()
			callBatchAPI(batch: eachBatch, withFilter: false) { status, data, _ in
				switch status {
				case .success:
					guard let data else {
						group.leave()
						return
					}
					result.merge(data) { _, new in new }
					group.leave()
				case .failure:
					group.leave()
				}
			}
		}
        
		group.notify(queue: .main) {
			completion(.success, result, "Success")
		}
	}

	// MARK: Internal

	func callBatchAPI(
		batch: [String],
		withFilter: Bool,
		completion: @escaping (_ status: Response,_ data: [String: Any]?,_ msg: String) -> Void) {
		var result = [String: Any]()
		// Serialize the new IP addresses into JSON data
		guard let jsonData = try? JSONSerialization.data(withJSONObject: batch, options: []) else {
			completion(.failure, nil, "Failed to serialize request body")
			return
		}
		// Set the request headers
		let headers = [
			"Authorization": "Bearer \(Constants.ACCESS_TOKEN)",
			"Content-Type": "application/json",
		]
		// Create the URL request with appropriate method, headers, and body
		var request = URLRequest(url: URL(string: Service.Router.batch(withFilter: withFilter).endPoint)!)
		request.httpMethod = "POST"
		request.allHTTPHeaderFields = headers
		request.httpBody = jsonData
		// Create a data task with the request
		let task = URLSession.shared.dataTask(with: request) { data, _, error in
			// Handle any error that occurred during the request
			if let error {
				completion(.failure, nil, error.localizedDescription)
				return
			}
			// Handle empty response data
			guard let data else {
				completion(.failure, nil, "Empty response data")
				return
			}
			do {
				let json = try JSONSerialization
					.jsonObject(with: data, options: []) as? [String: Any] // Deserialize incoming data into a JSON dictionary
				for eachIP in batch {
                    
					result[eachIP] = json?[eachIP]
                    
					if eachIP.starts(with: "AS") {
						if let asnData = result[eachIP] as? ASNResponse {
							CachingManager.shared.saveASNResult([eachIP: asnData])
						}
					} else if eachIP.ipType == .IPv4 || eachIP.ipType == .IPv6 {
						if let ipData = result[eachIP] as? IPResponse {
							CachingManager.shared.saveResult([eachIP: ipData])
						}
					}
				}
			} catch {
				// Handle any errors that occur during JSON serialization/deserialization
				completion(.failure, nil, "Failed to Save Bulk response in Cache")
			}
            
			completion(.success, result, "Success")
		}
		task.resume()
	}
    
}
