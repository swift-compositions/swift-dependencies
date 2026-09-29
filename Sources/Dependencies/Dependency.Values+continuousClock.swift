public import Witnesses

extension __DependencyValues {

    public var continuousClock: any Clock<Duration> {
        get { self[ContinuousClockKey.self] }
        set { self[ContinuousClockKey.self] = newValue }
    }
}
