public import Dependencies
public import Time
public import Witnesses

#if canImport(Darwin)
    import Darwin
#elseif canImport(Glibc)
    import Glibc
#elseif canImport(Musl)
    import Musl
#elseif os(Windows)
    import CRT
#endif

extension __DependencyGenerator.Date: Witness.Key {

    public static var liveValue: Self {
        Self { system() }
    }

    public static var testValue: Self {
        .constant(Time.Instant(secondsSinceUnixEpoch: 1_234_567_890))
    }

    private static func system() -> Time.Instant {
        var spec = timespec()
        _ = unsafe timespec_get(&spec, TIME_UTC)
        return Time.Instant(
            _unchecked: (),
            secondsSinceUnixEpoch: Int64(spec.tv_sec),
            nanosecondFraction: Int32(spec.tv_nsec)
        )
    }
}
