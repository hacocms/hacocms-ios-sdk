
import Foundation

class HacoConfig {
    var subDomain: String = ""
    var accessToken: String = ""
    var draftToken: String?
    var loggingRequest: Bool = false
    
    static let shared = HacoConfig()
    
    private init() {}
    
    func setup(subDomain: String, accessToken: String, draftToken: String?, loggingRequest: Bool) {
        self.subDomain = subDomain
        self.accessToken = accessToken
        self.draftToken = draftToken
        self.loggingRequest = loggingRequest
    }
}
