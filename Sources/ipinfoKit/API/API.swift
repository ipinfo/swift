//
//  File.swift
//
//
//

import Alamofire
import Foundation

// MARK: - Service.Router

extension Service {
    enum Router {
        case geoLocation(ipAddress: String)
        case ASN(asn: String)
        case batch(withFilter: Bool)
    }
}

extension Service.Router {
    @MainActor
    var endPoint: String {
        switch self {
        case .geoLocation(let ipAddress):
            "\(Service.shared.ipInfoURL)/\(ipAddress)/json"
        case .ASN(let asn):
            "\(Service.shared.ipInfoURL)/\(asn)/json"
        case .batch(let withFilter):
            "\(Service.shared.ipInfoURL)/batch" + (withFilter ? "&filter=1" : "")
        }
    }
}

// MARK: - Service

@MainActor
class Service {
    
    // MARK: Lifecycle
    
    private init() { }
    
    // MARK: Internal
    
    static let shared = Service()
    
    var ipInfoURL = "https://ipinfo.io"
    let headers: HTTPHeaders = [
        "Authorization": "Bearer \(Constants.ACCESS_TOKEN)",
    ]
    
    @MainActor
    func requestAPI(
        URL: Service.Router,
        method: HTTPMethod,
        params: Parameters? = nil,
        completion: @escaping (_ status: Response,_ data: Data,_ msg: String) -> Void) {
            
            AF.request(URL.endPoint , method: method, parameters: params , encoding: JSONEncoding.default, headers: headers)
                .response { response in
                    DispatchQueue.main.async {
                        switch response.result {
                        case .success(let value):
                            completion(.success, value ?? Data(), "Success")
                        case .failure(let err):
                            completion(.failure, Data(), err.localizedDescription)
                            break
                        }
                    }
                }
        }
}
