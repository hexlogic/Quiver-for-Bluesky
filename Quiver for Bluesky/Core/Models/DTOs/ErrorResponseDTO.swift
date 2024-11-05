struct ErrorResponseDTO: Decodable {
    let error: String
    let message: String
    
    // Optional fields that might come from the API
    let statusCode: Int?
    let errorType: String?
    
    enum CodingKeys: String, CodingKey {
        case error
        case message
        case statusCode = "status"
        case errorType = "type"
    }
}
