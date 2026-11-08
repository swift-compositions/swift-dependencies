internal import Clock_Concurrency
public import Witnesses

extension __DependencyValues {
    internal enum ClockKey: Witness.Key {
    }
}

extension __DependencyValues.ClockKey {
    typealias Value = Clock.`Any`<Duration>

    static var liveValue: Clock.`Any`<Duration> { Clock.`Any`(Swift::ContinuousClock()) }

    static var testValue: Clock.`Any`<Duration> { Clock.`Any`(Clock.Immediate()) }

    static var previewValue: Clock.`Any`<Duration> { Clock.`Any`(Clock.Immediate()) }
}
