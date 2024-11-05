import Foundation
import OSLog

// MARK: - Logger Definition
final class Logger {
    // MARK: - Log Levels
    enum Level: String {
        case debug = "📘 DEBUG"
        case info = "📗 INFO"
        case warning = "📒 WARNING"
        case error = "📕 ERROR"
        
        fileprivate var osLogType: OSLogType {
            switch self {
            case .debug: return .debug
            case .info: return .info
            case .warning: return .default
            case .error: return .error
            }
        }
    }
    
    // MARK: - Categories
    enum Category: String {
        case network = "Network"
        case auth = "Authentication"
        case ui = "UI"
        case data = "Data"
        case general = "General"
        
        fileprivate var subsystem: String {
            "com.yourapp.bluesky.\(rawValue.lowercased())"
        }
    }
    
    // MARK: - Properties
    private static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        return formatter
    }()
    
    private static var isDebugMode: Bool = {
#if DEBUG
        return true
#else
        return false
#endif
    }()
    
    // MARK: - Logging Methods
    static func debug(_ message: String, category: Category = .general, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .debug, category: category, file: file, function: function, line: line)
    }
    
    static func info(_ message: String, category: Category = .general, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .info, category: category, file: file, function: function, line: line)
    }
    
    static func warning(_ message: String, category: Category = .general, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .warning, category: category, file: file, function: function, line: line)
    }
    
    static func error(_ message: String, error: Error? = nil, category: Category = .general, file: String = #file, function: String = #function, line: Int = #line) {
        var fullMessage = message
        if let error = error {
            fullMessage += "\nError: \(error.localizedDescription)"
            if let nsError = error as NSError? {
                fullMessage += "\nCode: \(nsError.code)"
                if let underlyingError = nsError.userInfo[NSUnderlyingErrorKey] as? Error {
                    fullMessage += "\nUnderlying error: \(underlyingError)"
                }
            }
        }
        log(fullMessage, level: .error, category: category, file: file, function: function, line: line)
    }
    
    // MARK: - Private Methods
    private static func log(_ message: String, level: Level, category: Category, file: String, function: String, line: Int) {
        // Only log debug messages in debug mode
        if level == .debug && !isDebugMode {
            return
        }
        
        let timestamp = dateFormatter.string(from: Date())
        let fileName = (file as NSString).lastPathComponent
        let logMessage = "[\(timestamp)] [\(category.rawValue)] \(level.rawValue) [\(fileName):\(line)] \(function) -> \(message)"
        
        // Print to console in debug mode
#if DEBUG
        print(logMessage)
#endif
        
        // Log to OS logging system
        let osLog = OSLog(subsystem: category.subsystem, category: category.rawValue)
        os_log(level.osLogType, log: osLog, "%{public}@", message)
    }
}

// MARK: - Convenience Error Logging
extension Logger {
    static func logError(_ error: Error, category: Category = .general, file: String = #file, function: String = #function, line: Int = #line) {
        self.error("An error occurred", error: error, category: category, file: file, function: function, line: line)
    }
}

// MARK: - Network Logging Extension
extension Logger {
    static func logRequest(_ request: URLRequest, category: Category = .network) {
        var message = "Request: \(request.httpMethod ?? "Unknown") \(request.url?.absoluteString ?? "")\n"
        
        if let headers = request.allHTTPHeaderFields, !headers.isEmpty {
            message += "Headers: \(headers)\n"
        }
        
        if let body = request.httpBody,
           let bodyString = String(data: body, encoding: .utf8) {
            message += "Body: \(bodyString)"
        }
        
        debug(message, category: category)
    }
    
    static func logResponse(_ response: URLResponse?, data: Data?, error: Error?, category: Category = .network) {
        var message = "Response:\n"
        
        if let httpResponse = response as? HTTPURLResponse {
            message += "Status: \(httpResponse.statusCode)\n"
            message += "Headers: \(httpResponse.allHeaderFields)\n"
        }
        
        if let data = data,
           let jsonString = try? JSONSerialization.jsonObject(with: data),
           let prettyData = try? JSONSerialization.data(withJSONObject: jsonString, options: .prettyPrinted),
           let prettyString = String(data: prettyData, encoding: .utf8) {
            message += "Body: \(prettyString)\n"
        }
        
        if let error = error {
            self.error(message, error: error, category: category)
        } else {
            info(message, category: category)
        }
    }
}
