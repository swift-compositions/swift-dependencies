internal import Clock_Concurrency
public import Witnesses

extension __DependencyValues {
    internal enum ClockKey: Witness.Key {
    }
}

extension __DependencyValues.ClockKey {
    typealias Value = Clock.`Any`<Duration>

    #if hasFeature(Embedded)
        static var liveValue: Clock.`Any`<Duration> { Clock.`Any`(Clock.Unimplemented()) }
    #else
        static var liveValue: Clock.`Any`<Duration> { Clock.`Any`(Swift::ContinuousClock()) }
    #endif

    static var testValue: Clock.`Any`<Duration> { Clock.`Any`(Clock.Immediate()) }

    static var previewValue: Clock.`Any`<Duration> { Clock.`Any`(Clock.Immediate()) }
}
