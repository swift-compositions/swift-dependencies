#if Time
    public import Dependencies
    public import Time

    extension __DependencyGenerator {

        public struct Date: Sendable {

            internal let generate: @Sendable () -> Time.Instant

            public init(_ generate: @escaping @Sendable () -> Time.Instant) {
                self.generate = generate
            }
        }
    }

    extension __DependencyGenerator.Date {

        public var now: Time.Instant {
            generate()
        }

        public func callAsFunction() -> Time.Instant {
            generate()
        }
    }

    extension __DependencyGenerator.Date {

        public static func constant(_ instant: Time.Instant) -> Self {
            Self { instant }
        }
    }
#endif
