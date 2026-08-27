import Dependency

enum L1OnlyKey: Dependency.Key {
    static var liveValue: String { "l1-live" }
    static var testValue: String { "l1-test" }
}
