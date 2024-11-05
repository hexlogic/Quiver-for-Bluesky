import Foundation
import Combine

class AuthenticationManager {
    @Published private(set) var isAuthenticated = false
    private var accessToken: String?
    private var refreshToken: String?
    
    private let keychain = KeychainWrapper.standard
    private let tokenSubject = CurrentValueSubject<String?, Never>(nil)
    
    var tokenPublisher: AnyPublisher<String?, Never> {
        tokenSubject.eraseToAnyPublisher()
    }
    
    func setTokens(access: String, refresh: String) {
        accessToken = access
        refreshToken = refresh
        keychain.set(access, forKey: "accessToken")
        keychain.set(refresh, forKey: "refreshToken")
        tokenSubject.send(access)
        isAuthenticated = true
    }
    
    func clearTokens() {
        accessToken = nil
        refreshToken = nil
        keychain.removeObject(forKey: "accessToken")
        keychain.removeObject(forKey: "refreshToken")
        tokenSubject.send(nil)
        isAuthenticated = false
    }
}
