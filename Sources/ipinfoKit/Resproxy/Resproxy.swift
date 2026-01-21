//
//  Resproxy.swift
//
//
//

import Foundation

extension IPINFO {
    public func getResproxy(
        ip: String,
        completion:
            @escaping (_ status: Response, _ data: ResproxyResponse?, _ msg: String?) -> Void
    ) {
        Service.shared.requestAPI(URL: .resproxy(ipAddress: ip), method: .get) {
            status, data, msg in
            switch status {
            case .success:
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(ResproxyResponse.self, from: data)
                    completion(.success, response, nil)
                } catch {
                    completion(.failure, nil, error.localizedDescription)
                }
            case .failure:
                completion(.failure, nil, msg)
            }
        }
    }
}
