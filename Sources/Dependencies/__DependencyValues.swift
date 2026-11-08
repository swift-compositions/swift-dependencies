public import Clock_Concurrency
import Witnesses

extension __DependencyValues {

    /// A type-erased clock. It is immediate in tests and previews.
    public var clock: Clock.`Any`<Duration> {
        get { self[ClockKey.self] }
        set { self[ClockKey.self] = newValue }
    }
}
