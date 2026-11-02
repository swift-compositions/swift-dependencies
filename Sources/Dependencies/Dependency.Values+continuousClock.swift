public import Clock_Concurrency
public import Witnesses

extension __DependencyValues {

    /// The clock features sleep on. It keeps the caller's actor (``Clock/Nonsending``), so a test that sets
    /// `Clock.Test` here and advances it sees every effect of a wake-up.
    public var continuousClock: any Clock.Nonsending<Duration> {
        get { self[ContinuousClockKey.self] }
        set { self[ContinuousClockKey.self] = newValue }
    }
}
