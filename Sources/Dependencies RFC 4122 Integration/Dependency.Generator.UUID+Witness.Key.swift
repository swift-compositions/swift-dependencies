#if RFC4122
    public import Dependencies
    import RFC_4122
    public import Witnesses

    extension __DependencyGenerator.UUID: Witness.Key {

        public static var liveValue: Self {
            Self {
                unsafe RFC_4122.UUID.v4(fillRandom: { buffer in
                    var generator = SystemRandomNumberGenerator()
                    (0..<16).forEach { index in
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
