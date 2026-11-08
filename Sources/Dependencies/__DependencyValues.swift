public import Clock_Concurrency
import Witnesses

extension __DependencyValues {

    /// A type-erased clock. It is immediate in tests and previews.
    public var clock: Clock.`Any`<Duration> {
        get { self[ClockKey.self] }
        set { self[ClockKey.self] = newValue }
    }
}

extension __DependencyValues {

    public var context: Witness.Context.Mode {
        get { _mode ?? Witness.Context.currentMode }
        set { _mode = newValue }
    }
}

extension __DependencyValues {

    /// The clock features sleep on. It keeps the caller's actor (``Clock/Nonsending``), so a test that sets
    /// `Clock.Test` here and advances it sees every effect of a wake-up.
    public var continuousClock: any Clock.Nonsending<Duration> {
        get { self[ContinuousClockKey.self] }
        set { self[ContinuousClockKey.self] = newValue }
    }
}
