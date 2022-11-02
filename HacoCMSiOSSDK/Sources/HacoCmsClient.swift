
import Foundation
import Combine
import Alamofire
import Moya

public class HacoCmsClient {
    
    public init(subDomain: String, accessToken: String, draftToken: String?, loggingRequest: Bool = false) {
        HacoConfig.shared.setup(
            subDomain: subDomain,
            accessToken: accessToken,
            draftToken: draftToken,
            loggingRequest: loggingRequest
        )
    }
    
    
    /// Get conent list
    /// - Parameters:
    ///   - returnType: Decodable protocol
    ///   - path: path of API
    ///   - query: Parameters for request
    ///   - includingDraft: Retrieve the list of content that include draft content
    /// - Returns: AnyPublisher<Decodable, Error>
    public func getListContent<D: Decodable>(
        returnType: D.Type,
        path: String,
        query: QueryBuilder? = nil,
        includingDraft: Bool = false
    ) -> AnyPublisher<D, Error> {
        
        return requestAPI(
            .getListContent(path: path, query: query, includingDraft: includingDraft),
            returnType: returnType
        )
    }
    
    /// Get conent list
    /// - Parameters:
    ///   - returnType: Decodable protocol
    ///   - path: path of API
    ///   - query: Parameters for request
    ///   - includingDraft: Retrieve the list of content that include draft content
    /// - Returns: Result<D, Error>
    public func getListContent<D: Decodable>(
        returnType: D.Type,
        path: String,
        query: QueryBuilder? = nil,
        includingDraft: Bool = false,
        completion: @escaping (Result<D, Error>) -> Void
    ) {
        
        return requestAPIClosure(.getListContent(path: path, query: query, includingDraft: includingDraft), returnType: returnType, completion: completion)
    }
    
    
    /// Get single content
    /// - Parameters:
    ///   - returnType: Decodable protocol
    ///   - path: Path of api
    /// - Returns: AnyPublisher<Decodable, Error>
    public func getSingleContent<D: Decodable>(returnType: D.Type, path: String) -> AnyPublisher<D, Error> {
        return requestAPI(.getSingleContent(path: path), returnType: returnType)
    }
    
    /// Get single content
    /// - Parameters:
    ///   - returnType: Decodable protocol
    ///   - path: Path of api
    /// - Returns: Result<D, Error>
    public func getSingleContent<D: Decodable>(returnType: D.Type, path: String, completion: @escaping (Result<D, Error>) -> Void) {
        return requestAPIClosure(.getSingleContent(path: path), returnType: returnType, completion: completion)
    }
    
    
    /// Get detail content
    /// - Parameters:
    ///   - returnType: Decodable protocol
    ///   - path: Path of api
    ///   - contentId: ID of content
    ///   - draftToken: Token for retrieving unpublished content
    /// - Returns: AnyPublisher<Decodable, Error>
    public func getDetailContent<D: Decodable>(returnType: D.Type, path: String, contentId: String, draftToken: String? = nil) -> AnyPublisher<D, Error> {
        return requestAPI(.getDetailContent(path: path, contentId: contentId, draftToken: draftToken), returnType: returnType)
    }
    
    /// Get detail content
    /// - Parameters:
    ///   - returnType: Decodable protocol
    ///   - path: Path of api
    ///   - contentId: ID of content
    ///   - draftToken: Token for retrieving unpublished content
    /// - Returns: AnyPublisher<Decodable, Error>
    public func getDetailContent<D: Decodable>(returnType: D.Type, path: String, contentId: String, draftToken: String? = nil, completion: @escaping (Result<D, Error>) -> Void) {
        return requestAPIClosure(.getDetailContent(path: path, contentId: contentId, draftToken: draftToken), returnType: returnType, completion: completion)
    }
    
    func requestAPI<D: Decodable>(_ endPoint: HacoEndpoint, returnType: D.Type) -> AnyPublisher<D, Error> {
        let provider = MoyaProvider<HacoEndpoint>(session: DefaultAlamofireSession.shared)
        
        if HacoConfig.shared.loggingRequest {
            loggingRequest(endPoint)
        }
        
        return Deferred {
            Future { promise in
                
                provider.request(endPoint) { result in
                    switch result {
                    case .success(let response):
                        do {
                            
                            let dataDecode = try response.map(D.self)
                            promise(.success(dataDecode))
                        } catch {
                            print("[Failed to decode response] - Error:\n\(error)")
                        }
                        
                    case .failure(let error):
                        promise(.failure(error))
                        
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func requestAPIClosure<D: Decodable>(_ endPoint: HacoEndpoint, returnType: D.Type, completion: @escaping (Result<D, Error>) -> Void) {
        let provider = MoyaProvider<HacoEndpoint>(session: DefaultAlamofireSession.shared)
        
        if HacoConfig.shared.loggingRequest {
            loggingRequest(endPoint)
        }
        
        provider.request(endPoint) { result in
            switch result {
            case .success(let response):
                do {
                    
                    let dataDecode = try response.map(D.self)
                    
                    completion(.success(dataDecode))
                } catch {
                    print("[Failed to decode response] - Error:\n\(error)")
                }
                
            case .failure(let error):
                completion(.failure(error))
                
            }
        }
    }
    
    func loggingRequest(_ endPoint: TargetType) {
        print("====================== REQUEST ========================")
        print("Base url: \(endPoint.baseURL)")
        print("Path: \(endPoint.path)")
        print("Method: \(endPoint.method)")
        if let header = endPoint.headers {
            print("Header: \(header)")
        }
        print("Params: \(endPoint.task)")
        print("========================================================")

    }
    
}

extension Publisher {
    
    public func convertToResult() -> AnyPublisher<Result<Output, Failure>, Never> {
        return self.map(Result.success)
            .catch { Just(.failure($0)) }
            .eraseToAnyPublisher()
    }
    
}

class DefaultAlamofireSession: Alamofire.Session {
    static let shared: DefaultAlamofireSession = {
        let configuration = URLSessionConfiguration.default
        configuration.headers = .default
        configuration.requestCachePolicy = .reloadIgnoringCacheData
        return DefaultAlamofireSession(configuration: configuration)
    }()
}
