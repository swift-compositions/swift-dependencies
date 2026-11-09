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

        /// An incrementing generator starting at zero, one per dependency root.
        ///
        /// Each `.dependencies` test root starts its own sequence; reads outside
        /// any such root share the default root's sequence.
        public static var testValue: Self {
            sequences.generator(for: __DependencyContext.root)
        }

        private static let sequences = Sequences()
    }
#endif
