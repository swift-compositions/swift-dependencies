public import Witnesses

extension __DependencyValues {

    internal enum ContinuousClockKey: Witness.Key {

        typealias Value = any Clock<Duration>

        static var liveValue: any Clock<Duration> { ContinuousClock() }
    }
}
