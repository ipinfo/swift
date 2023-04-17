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
