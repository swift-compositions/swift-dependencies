internal import Clock_Concurrency
public import Witnesses

extension __DependencyValues {
    internal enum ContinuousClockKey: Witness.Key {
    }
}

#if hasFeature(Embedded)
    extension __DependencyValues.ContinuousClockKey {
        typealias Value = Clock.Hosted

        static var liveValue: Clock.Hosted {
            Clock.Hosted(
                elapsed: { .zero },
                schedule: { _, _ in
                    fatalError("Nothing set the continuous clock; a program under Embedded Swift sets the clock it runs on")
                }
            )
        }

        static var testValue: Clock.Hosted {
            Clock.Hosted(elapsed: { .zero }, schedule: { _, wake in wake() })
        }
    }
#else
    extension __DependencyValues.ContinuousClockKey {
        typealias Value = any Clock.Nonsending<Duration>

        static var liveValue: any Clock.Nonsending<Duration> { ContinuousClock() }

        static var testValue: any Clock.Nonsending<Duration> { Clock.Immediate() }
    }
#endif
