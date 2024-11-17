import Foundation

struct DateFormatterConfig {
    static let iso8601Formatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
}

@propertyWrapper
struct ISO8601Date {
    var wrappedValue: Date
    
    init(wrappedValue: Date) {
        self.wrappedValue = wrappedValue
    }
}

extension ISO8601Date: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let dateString = try container.decode(String.self)
        
        if let date = DateFormatterConfig.iso8601Formatter.date(from: dateString) {
            self.wrappedValue = date
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Date string does not match format")
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        let dateString = DateFormatterConfig.iso8601Formatter.string(from: wrappedValue)
        try container.encode(dateString)
    }
}
