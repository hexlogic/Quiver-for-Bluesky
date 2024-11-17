protocol NetworkClientProtocol: Service {
    func request<T: Decodable>(
        endpoint: Endpoint,
        method: HTTPMethod,
        queryParameters: [String: Any],
        body: Encodable?
    ) async throws -> T
}
