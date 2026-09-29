public import Witnesses

extension __DependencyValues {

    internal enum ContinuousClockKey: Witness.Key {

        static var liveValue: any Clock<Duration> { ContinuousClock() }
    }
}
