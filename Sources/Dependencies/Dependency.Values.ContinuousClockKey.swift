internal import Clock_Concurrency
public import Witnesses

extension __DependencyValues {
    internal enum ContinuousClockKey: Witness.Key {
    }
}

extension __DependencyValues.ContinuousClockKey {
    typealias Value = any Clock.Nonsending<Duration>

    static var liveValue: any Clock.Nonsending<Duration> { ContinuousClock() }
}
