import Foundation

func retryOnNetworkErrors<T>(
    maxAttempts: Int = 3,
    delay: TimeInterval = 1,
    retryableErrors: [Error] = [],
    operation: () async throws -> T
) async throws -> T {
    var lastError: Error?
    
    for attempt in 0..<maxAttempts {
        do {
            return try await operation()
        } catch let error as NetworkError {
            // Check if this error should trigger a retry
            switch error {
            case .networkError, .serverError:  // Add cases you want to retry
                lastError = error
                if attempt < maxAttempts - 1 {
                    try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                    continue
                }
            default:
                throw error  // Don't retry other errors
            }
        }
    }
    
    throw lastError!
}
