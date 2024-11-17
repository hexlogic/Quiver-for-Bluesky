import Foundation
import SwiftUI

class AuthViewModel: ObservableObject {
    @Published var session: SessionModel?
    @Published var errorMessage: String?
    
    
    @Published var isLoading: Bool = false
    
    private var timers: [Timer] = []
    
    @Inject private var blueskyService: BlueskyService
    
    init() {
        let timer = Timer.scheduledTimer(withTimeInterval: 15*60, repeats: true) {[weak self] _ in
            Task {
                await self?.silentLogin()
            }
        }
        timers.append(timer)
    }
    
    deinit {
        timers.forEach { timer in
            timer.invalidate()
        }
        timers.removeAll()
    }
    
    @MainActor
    func silentLogin() async {
        do {
            let token = try TokenManager.getAccessToken()
            if let _ = token {
                let session = try await blueskyService.getSession()
                self.session = session
            }
        }
        catch let error as NetworkError {
            switch error {
            case .serverError(let dto):
                if dto.error == "ExpiredToken"{
                    await refreshSession()
                }
            default:
                Logger.error("AuthViewModel::silentLogin:", error: error)
            }
        }
        catch {
            Logger.error("AuthViewModel::silentLogin:", error: error)
        }
    }
    
    @MainActor
    func createSession(identifier: String, password: String) async {
        isLoading = true
        
        defer  {
            isLoading = false
        }
        do {
            let session = try await blueskyService.createSession(loginDTO: .init(identifier: identifier, password: password))
            self.session = session
            try TokenManager.saveTokens(accessToken: session.accessJwt ?? "", refreshToken: session.refreshJwt ?? "")
        }
        catch let error as NetworkError {
            switch error {
            case .authenticationRequired:
                errorMessage = "Username or password is incorrect"
            default:
                break;
            }
        }
        catch {
            Logger.error("AuthViewModel::createSession:", error: error)
        }
    }
    
    @MainActor
    func refreshSession() async {
        do {
            self.session = try await blueskyService.refreshSession()
            try TokenManager.saveTokens(accessToken: session?.accessJwt ?? "", refreshToken: session?.refreshJwt ?? "")
        } catch {
            Logger.error("AuthViewModel::refreshSession:", error: error)
        }
    }
    
    @MainActor
    func deleteSession() async {
        do {
            try await blueskyService.deleteSession()
            self.session = nil
        } catch {
            Logger.error("AuthViewModel::deleteSession:", error: error)
        }
    }
}
