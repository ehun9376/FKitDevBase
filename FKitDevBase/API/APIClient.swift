import Foundation

enum HttpMethods: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

enum ApiAction {
    case login
    case searchPosition
    
    var path: String {
        switch self {
        case .login:
            return "login"
        case .searchPosition:
            return "apiEx/other/search/find-job"
        }
    }
}

enum HttpHeader {
    case json
    case form
    case none
    
    var header: [String: String] {
        switch self {
        case .json:
            return [
                "Content-type": "application/json",
                "Accept": "application/json"
            ]
        case .form:
            return [
                "Content-type": "application/x-www-form-urlencoded",
                "Accept": "application/json"
            ]
        case .none:
            return [:]
        }
    }
}

struct ApiClinet {
    static let baseUrl = "https://webapi.1111.com.tw/"
    static let maxRetries = 3
    static let retryDelay: TimeInterval = 1.0
    
    static func connectApi(httpMethod: HttpMethods = .post,
                         apiAction: ApiAction,
                         header: HttpHeader = .json,
                         suffix: String? = nil,
                         parameter: [String: Any]? = nil,
                         listParameter: [[String: Any]]? = nil) async throws -> Result<Any?> {
        var lastError: Error?
        
        for attempt in 0..<maxRetries {
            do {
                let result = try await performRequest(
                    httpMethod: httpMethod,
                    apiAction: apiAction,
                    header: header,
                    suffix: suffix,
                    parameter: parameter,
                    listParameter: listParameter
                )
                return result
            } catch {
                lastError = error
                if attempt < maxRetries - 1 {
                    debugPrint("ApiClient: Attempt \(attempt + 1) failed, retrying after delay...")
                    try await Task.sleep(nanoseconds: UInt64(retryDelay * 1_000_000_000))
                }
            }
        }
        
        throw lastError ?? NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "All retry attempts failed"])
    }
    
    private static func performRequest(
        httpMethod: HttpMethods,
        apiAction: ApiAction,
        header: HttpHeader,
        suffix: String?,
        parameter: [String: Any]?,
        listParameter: [[String: Any]]?
    ) async throws -> Result<Any?> {
        guard let apiUrl = URL(string: "\(baseUrl)\(apiAction.path)/\(suffix ?? "")") else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }
        
        var request = URLRequest(url: apiUrl)
        request.httpMethod = httpMethod.rawValue
        request.allHTTPHeaderFields = header.header
        
        if let parameter = parameter {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameter, options: [])
        } else if let listParameter = listParameter {
            request.httpBody = try JSONSerialization.data(withJSONObject: listParameter, options: [])
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
        }
        
        debugPrint("ApiClient: request URL: \(apiUrl)\nbody: \(String(data: data, encoding: .utf8) ?? "")")
        debugPrint("ApiClient: statusCode: \(httpResponse.statusCode)\nbody: \(String(data: data, encoding: .utf8) ?? "")")
        
        if httpResponse.statusCode == 200 {
            let decodedData = try JSONSerialization.jsonObject(with: data, options: [])
            return Result(errorMessage: nil, model: decodedData)
        } else {
            throw NSError(domain: "", code: httpResponse.statusCode, userInfo: [
                NSLocalizedDescriptionKey: "HTTP error: \(httpResponse.statusCode)"
            ])
        }
    }
}
