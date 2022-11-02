
import Foundation

// QUERY PARAMETERS for API
// Reference from https://hacocms.com/references/content-api

public class QueryBuilder {
    /**
     Example: q=pet[eq]:cat[+]createdAt[ge]:2021-10-01
     Search filter query
     format:q={field_id}[{predicate}}]:{value}[+]...
     
     - URL encoding required
     - AND condition with [+]
     
     Reference more from: https://hacocms.com/references/content-api#tag/%E3%82%B3%E3%83%B3%E3%83%86%E3%83%B3%E3%83%84/paths/~1api~1v1~1{endpoint}/get
     */
    var q: String?
    /**
     Example: ids=unique-value-01,unique-value-02
     Multiple content ID specification query
     format:ids={content_id},{content_id}...
     
     Up to 100 items can be specified.
     */
    var ids: String?
    /**
     Example: limit=100
     Specify the number of acquisitions. The default value is 100.
     */
    var limit: Int?
    /**
     Example: offset=100
     Specifies the acquisition start position. Default value is 0.
     */
    var offset: Int?
    /**
     Example: search=Weather
     Search the entire normal search
     JSON. meta information is not covered.
     */
    var search: String?
    /**
     Example: s=title,-updatedAt
     Sort query
     format: s={sign}{field_id},{sign}...
     
     - sign: Only "-" can be specified (ascending order if not specified, descending order if specified)
     - Types other than dates, booleans, and numbers are compared as strings.
     */
    var s: String?
    
    /**
     Example: status=0
     status
     */
    var status: Int?
    
    public init(q: String? = nil, ids: String? = nil, limit: Int? = nil, offset: Int? = nil, search: String? = nil, s: String? = nil, status: Int? = nil) {
        self.q = q
        self.ids = ids
        self.limit = limit
        self.offset = offset
        self.search = search
        self.s = s
        self.status = status
    }
    
    public func build() -> [String: Any] {
        var parameters: [String: Any?] = [
            "q": q,
            "ids": ids,
            "limit": limit,
            "offset": offset,
            "search": search,
            "s": s,
            "status": status
        ]
        
        return parameters.flattenValues()
    }
    
}

extension Dictionary {
    func flatMapValues<T>(_ transform: (Value) throws -> T?) rethrows -> [Key: T] {
        var result: [Key: T] = [:]
        for (key, value) in self {
            if let transformed = try transform(value) {
                result[key] = transformed
            }
        }
        return result
    }

    func flattenValues<U>() -> [Key: U] where Value == U? {
        return flatMapValues { $0 }
    }
}
