internal import Clock_Concurrency
public import Witnesses

#if hasFeature(Embedded)
    extension __DependencyValues {
        internal enum ContinuousClockKey: Witness.Key.Test {
        }
    }

    extension __DependencyValues.ContinuousClockKey {
        typealias Value = Clock.Hosted

        static var testValue: Clock.Hosted {
            Clock.Hosted(elapsed: { .zero }, schedule: { _, wake in wake() })
        }
    }
#else
    extension __DependencyValues {
        internal enum ContinuousClockKey: Witness.Key {
        }
    }

    extension __DependencyValues.ContinuousClockKey {
        typealias Value = any Clock.Nonsending<Duration>

        static var liveValue: any Clock.Nonsending<Duration> { ContinuousClock() }

        static var testValue: any Clock.Nonsending<Duration> { Clock.Immediate() }
    }
#endif
