
import Foundation
import Moya

enum HacoEndpoint {
    
    case getListContent(path: String, query: QueryBuilder?, includingDraft: Bool)
    case getSingleContent(path: String)
    case getDetailContent(path: String, contentId: String, draftToken: String?)
}

extension HacoEndpoint: TargetType {}

// MARK: - Base URL
extension HacoEndpoint {
    
    public var baseURL: URL {
        guard let url = URL(string: "https://\(HacoConfig.shared.subDomain).hacocms.com/api/v1" ) else {
            fatalError("base URL could not be configured")
        }
        return url
    }
    
}

// MARK: - PATH
extension HacoEndpoint {
    
    public var path: String {
        switch self {
        case .getListContent(let path, _, _):
            return path
        case .getSingleContent(let path):
            return path
        case .getDetailContent(let path, _, _):
            return path
        }
    }
}

// MARK: - METHOD
extension HacoEndpoint {
    
    public var method: Moya.Method {
        switch self {
        default: return .get
        }
    }
    
}

// MARK: - TASK
extension HacoEndpoint {
    
    public var task: Task {
        switch self {
        case .getSingleContent:
            return .requestPlain
        case .getListContent(_, let query, _):
            return parametersQuery(params: query?.build())
        case .getDetailContent(_, _, let draftToken):
            if let draftToken = draftToken {
                return parametersQuery(params: ["draft": draftToken])
            }
            return .requestPlain
        }
    }
    
    private func parametersJsonBody(params: [String : Any]) -> Task {
        return .requestParameters(parameters: params, encoding: JSONEncoding.default)
    }
    
    private func parametersQuery(params: [String : Any]?) -> Task {
        if let params = params {
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
        return .requestParameters(parameters: [:], encoding: URLEncoding.default)
    }
}

// MARK: - HEADERS
extension HacoEndpoint {
    
    var includePrjDraftToken: Bool {
        switch self {
        case .getListContent(_, _, let includingDraft):
            return includingDraft
        default:
            return true
        }
    }
    
    public var headers: [String: String]? {
        var _headers: [String: String] = [:]
        _headers["Authorization"] = "Bearer \(HacoConfig.shared.accessToken)"
        
        if includePrjDraftToken, let draftToken = HacoConfig.shared.draftToken {
            _headers["Haco-Project-Draft-Token"] = draftToken
        }
        
        return _headers
    }
    
}

extension HacoEndpoint {
    var validationType: ValidationType {
        return .successCodes
    }
}
