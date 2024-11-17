import Foundation
import Security

enum KeychainError: Error {
    case duplicateEntry
    case unknown(OSStatus)
    case itemNotFound
    case invalidData
}

class KeychainManager {
    static let shared = KeychainManager()
    private init() {}
    
    func saveToken(_ token: String, forKey key: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: token.data(using: .utf8)!,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecDuplicateItem {
            try updateToken(token, forKey: key)
        } else if status != errSecSuccess {
            throw KeychainError.unknown(status)
        }
    }
    
    func getToken(forKey key: String) throws -> String {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess else {
            throw KeychainError.itemNotFound
        }
        
        guard let data = result as? Data,
              let token = String(data: data, encoding: .utf8) else {
            throw KeychainError.invalidData
        }
        
        return token
    }
    
    private func updateToken(_ token: String, forKey key: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        let attributes: [String: Any] = [
            kSecValueData as String: token.data(using: .utf8)!
        ]
        
        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        
        guard status == errSecSuccess else {
            throw KeychainError.unknown(status)
        }
    }
    
    func deleteToken(forKey key: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        guard status == errSecSuccess else {
            throw KeychainError.unknown(status)
        }
    }
}

class TokenManager {
    private static let accessTokenKey = "com.synckord.quiver.accessToken"
    private static let refreshTokenKey = "com.synckord.quiver.refreshToken"
    
    static func saveTokens(accessToken: String, refreshToken: String) throws {
        try KeychainManager.shared.saveToken(accessToken, forKey: accessTokenKey)
        try KeychainManager.shared.saveToken(refreshToken, forKey: refreshTokenKey)
    }
    
    static func getAccessToken() throws -> String? {
        do {
            return try KeychainManager.shared.getToken(forKey: accessTokenKey)
        } catch {
            return nil
        }
    }
    
    static func getRefreshToken() throws -> String? {
        do {
            return try KeychainManager.shared.getToken(forKey: refreshTokenKey)
        } catch {
            return nil
        }
    }
    
    static func clearTokens() throws {
        try KeychainManager.shared.deleteToken(forKey: accessTokenKey)
        try KeychainManager.shared.deleteToken(forKey: refreshTokenKey)
    }
}
