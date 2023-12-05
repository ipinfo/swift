//
//  File.swift
//
//
//  Created by mslm on 30/03/2023.
//

import Foundation
import Alamofire

extension Service{
    enum Router{
        case geoLocation(ipAddress: String)
        case ASN(asn: String)
        case batch(withFilter: Bool)
    }
}

extension Service.Router{
    
    var endPoint: String{
        switch self {
        case .geoLocation(let ipAddress):
            return "\(Service.shared.ipInfoURL)/\(ipAddress)/json"
        case .ASN(let asn):
            return "\(Service.shared.ipInfoURL)/\(asn)/json"
        case .batch(let withFilter):
            return "\(Service.shared.ipInfoURL)/batch" + (withFilter ? "&filter=1" : "")
        }
    }
}

class Service{
    var ipInfoURL = "https://ipinfo.io"
    static let shared = Service()
    let headers: HTTPHeaders = [
        "Authorization": "Bearer \(Constants.ACCESS_TOKEN)"
    ]
    
    private init(){
        
    }
    
    func requestAPI(URL: Service.Router, method: HTTPMethod, params: Parameters? = nil, completion: @escaping (_ status: Response,_ data: Data,_ msg: String)->()){
        
        AF.request(URL.endPoint , method: method, parameters: params , encoding: JSONEncoding.default, headers: headers).response { response in
            switch response.result{
            case .success(let value):
                completion(.success, value ?? Data(), "Success")
            case .failure(let err):
                completion(.failure, Data(), err.localizedDescription)
                print(err.localizedDescription)
                break
            }
        }
    }
}
