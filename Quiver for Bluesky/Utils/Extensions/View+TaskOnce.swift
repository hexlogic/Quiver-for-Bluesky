import SwiftUI

struct TaskOnceViewModifier: ViewModifier {
    @State private var hasRun = false
    let task: () async -> Void
    
    func body(content: Content) -> some View {
        content.task {
            guard !hasRun else { return }
            hasRun = true
            await task()
        }
    }
}

extension View {
    func taskOnce(_ task: @escaping () async -> Void) -> some View {
        modifier(TaskOnceViewModifier(task: task))
    }
}
