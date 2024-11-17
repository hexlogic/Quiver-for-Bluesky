protocol Service {
    // Empty protocol as base for all injectable services
}

final class DependencyContainer {
    private var services: [String: Any] = [:]
    static let shared = DependencyContainer()
    
    private init() {}
    
    func register<T: Service>(_ service: T) {
        let key = String(describing: T.self)
        services[key] = service
    }
    
    func resolve<T: Service>() -> T? {
        let key = String(describing: T.self)
        return services[key] as? T
    }
}

@propertyWrapper
struct Inject<T: Service> {
    private let service: T?
    
    var wrappedValue: T {
        guard let service = service else {
            fatalError("Service \(T.self) not registered")
        }
        return service
    }
    
    init() {
        self.service = DependencyContainer.shared.resolve()
    }
}
