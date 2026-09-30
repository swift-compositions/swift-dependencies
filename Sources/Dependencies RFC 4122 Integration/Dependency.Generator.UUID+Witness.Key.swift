#if RFC4122
public import Dependencies
public import RFC_4122
public import Witnesses

extension __DependencyGenerator.UUID: Witness.Key {

    public static var liveValue: Self {
        Self {
            RFC_4122.UUID.v4(fillRandom: { buffer in
                var generator = SystemRandomNumberGenerator()
                for index in 0..<16 {
                    unsafe buffer[index] = generator.next()
                }
            })
        }
    }

    public static var testValue: Self {
        shared
    }

    private static let shared = Self.incrementing
}
#endif
