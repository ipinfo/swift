import Foundation
import Network

open class IPINFO{
    
    //MARK:  Variables
    public static let `shared` = IPINFO()
    
    public var accessToken: String{
        get{
            Bundle.main.accessToken ?? emptyString
        }
    }
    
    private init(){
        getDataFromCache()
    }
}

extension String{
    
    var isValidIP: Bool {
        
        var sin = sockaddr_in()
        var sin6 = sockaddr_in6()
        
        if self.withCString({ cstring in inet_pton(AF_INET6, cstring, &sin6.sin6_addr) }) == 1 {
            // IPv6 peer.
            return true
        }
        
        else if self.withCString({ cstring in inet_pton(AF_INET, cstring, &sin.sin_addr) }) == 1 {
            // IPv4 peer.
            return true
        }
        
        return false
        
    }
}


