public import Dependencies
public import Environment

extension Dependency.Values {
    public enum EnvironmentKey: Dependency.Key {
    }
}

extension Dependency.Values.EnvironmentKey {
    public typealias Value = Environment.Snapshot

    #if os(WASI)
        public static var liveValue: Environment.Snapshot { Environment.Snapshot() }
    #else
        public static var liveValue: Environment.Snapshot { .effective() }
    #endif

    public static var testValue: Environment.Snapshot { Environment.Snapshot() }
}

extension Dependency.Values {
    public var environment: Environment.Snapshot {
        get { self[EnvironmentKey.self] }
        set { self[EnvironmentKey.self] = newValue }
    }
}
