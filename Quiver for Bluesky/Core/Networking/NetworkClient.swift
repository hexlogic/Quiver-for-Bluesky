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
        urlComponents.queryItems = parameters.map { key, value in
            URLQueryItem(name: key, value: "\(value)")
        }
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
    private let authManager: AuthenticationManager
    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    
    private let baseURL: URL
    
    init(
        baseURL: URL = URL(string: "https://public.api.bsky.app/xrpc")!,
        authManager: AuthenticationManager,
        session: URLSession = .shared
    ) {
        self.authManager = authManager
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
        
        let request = try builder.build()
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
                let errorResponse = try? decoder.decode(ErrorResponseDTO.self, from: data)
                throw NetworkError.serverError(errorResponse?.message ?? "Unknown error")
            }
        } catch let error as NetworkError {
            Logger.error(error.localizedDescription, category: .network)
            throw error
        } catch {
            Logger.error(error.localizedDescription, category: .network)
            throw NetworkError.networkError(error)
        }
    }
    
    private func getValidToken() async throws -> String {
        // Implement token refresh logic here
        return ""
    }
}
