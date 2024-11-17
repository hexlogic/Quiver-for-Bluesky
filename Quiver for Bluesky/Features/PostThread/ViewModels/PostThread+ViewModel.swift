import SwiftUI

class PostThreadViewModel: ObservableObject {
    @Inject private var blueskyService: BlueskyService
    
    @Published var thread: ThreadModel?
    @Published var isLoading: Bool = false
    
    @MainActor
    func initPostThread(at uri: String?) async {
        isLoading = true
        defer { isLoading = false }
        do {
            let threadResponse = try await blueskyService.getPostThread(at: uri)
            thread = threadResponse.thread
        } catch {
            Logger.error("PostThreadViewModel::initPostThread:", error: error)
        }
    }
}
