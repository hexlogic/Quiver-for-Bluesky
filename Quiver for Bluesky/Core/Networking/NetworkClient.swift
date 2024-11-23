import Foundation

struct RequestBuilder {
    private var urlComponents: URLComponents
    private var method: HTTPMethod
    private var headers: [String: String]
    private var body: Data?
    
    init(baseURL: URL, path: String, method: HTTPMethod = .get) {
        self.urlComponents = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: true) ?? URLComponents()
        self.method = method
        self.headers = [:]
    }
    
    mutating func setQueryParameters(_ parameters: [String: Any]) -> RequestBuilder {
        var components = self.urlComponents
        
        let queryItems = parameters.flatMap { (key, value) -> [URLQueryItem] in
            if let array = value as? [String] {
                // Handle array parameters by creating multiple query items with the same key
                return array.map { URLQueryItem(name: key, value: $0) }
            } else {
                // Handle regular single-value parameters
                return [URLQueryItem(name: key, value: "\(value)")]
            }
        }
        
        components.queryItems = queryItems
        
        
        self.urlComponents = components
        
        
        return self
    }
    
    mutating func setBody(_ body: Encodable) throws -> RequestBuilder {
        self.body = try JSONEncoder().encode(body)
        return self
    }
    
    mutating func setHeaders(_ headers: [String: String]) -> RequestBuilder {
        self.headers = headers
        return self
    }
    
    func build() throws -> URLRequest {
        guard let url = urlComponents.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = body
        
        return request
    }
}

class NetworkClient: NetworkClientProtocol {
    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    
    private var baseURL: URL
    
    init(
        baseURL: URL = URL(string: "https://bsky.social/xrpc")!,
        session: URLSession = .shared
    ) {
        self.session = session
        self.decoder = JSONDecoder()
        self.encoder = JSONEncoder()
        self.baseURL = baseURL
        
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        encoder.keyEncodingStrategy = .convertToSnakeCase
    }
    
    func request<T: Decodable>(
        endpoint: Endpoint,
        method: HTTPMethod = .get,
        queryParameters: [String: Any] = [:],
        body: Encodable? = nil
    ) async throws -> T {
        let token = try? TokenManager.getAccessToken()
        let refreshToken = try? TokenManager.getRefreshToken()
        if token == nil && endpoint != .createSession {
            baseURL = URL(string: "https://public.api.bsky.app/xrpc")!
        } else {
            baseURL = URL(string: "https://bsky.social/xrpc")!
        }
        var builder = RequestBuilder(baseURL: baseURL, path: endpoint.path, method: method)
        
        // Add query parameters if present
        if !queryParameters.isEmpty {
            let _ = builder.setQueryParameters(queryParameters)
        }
        
        // Add body for non-GET requests
        if method != .get, let body = body {
            let _ = try builder.setBody(body)
        }
        
        // Set common headers
        let _ = builder.setHeaders([
            "Content-Type": "application/json",
            "Accept": "application/json"
        ])
        
        
        
        
        var request = try builder.build()
        
        if token != nil && endpoint != .refreshSession {
            request.setValue("Bearer \(token!)", forHTTPHeaderField: "Authorization")
        }
        
        if endpoint == .refreshSession && refreshToken != nil {
            request.setValue("Bearer \(refreshToken!)", forHTTPHeaderField: "Authorization")
        }
        
        Logger.logRequest(request)
        
        do {
            Logger.logRequest(request)
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            Logger.logResponse(httpResponse, data: data, error: nil)
            
            switch httpResponse.statusCode {
            case 200..<300:
                return try decoder.decode(T.self, from: data)
            case 401:
                throw NetworkError.authenticationRequired
            default:
                let errorResponse = try? decoder.decode(ErrorResponse.self, from: data)
                if let errorResponse = errorResponse {
                    throw NetworkError.serverError(errorResponse)
                } else {
                    throw NetworkError.unknownError
                }
            }
        } catch let error as NetworkError {
            Logger.error(error.localizedDescription, error: error, category: .network)
            throw error
        } catch {
            Logger.error(error.localizedDescription, error: error, category: .network)
            throw NetworkError.networkError(error)
        }
    }
    
    private func getValidToken() async throws -> String {
        // Implement token refresh logic here
        return ""
    }
}
