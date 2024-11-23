import Foundation

func parseAtURL(_ url: String) -> (did: String, recordKey: String)? {
    let withoutPrefix = url.replacingOccurrences(of: "at://", with: "")
    let components = withoutPrefix.components(separatedBy: "/")
    
    guard components.count >= 3 else { return nil }
    return (did: components[0], recordKey: components[2])
}
