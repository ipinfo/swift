import Foundation
import Network

open class IPINFO{
    
    //MARK:  Variables
    public static let `shared` = IPINFO()
    internal static let batchMaxSize = 1000

    public var accessToken: String{
        get{
            Bundle.main.accessToken ?? emptyString
        }
    }
}
