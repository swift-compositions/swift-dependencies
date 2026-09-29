public import Dependencies
public import RFC_4122

extension __DependencyGenerator {

    public struct UUID: Sendable {

        internal let generate: @Sendable () -> RFC_4122.UUID

        public init(_ generate: @escaping @Sendable () -> RFC_4122.UUID) {
            self.generate = generate
        }
    }
}

extension __DependencyGenerator.UUID {

    public func callAsFunction() -> RFC_4122.UUID {
        generate()
    }
}

extension __DependencyGenerator.UUID {

    public static func constant(_ uuid: RFC_4122.UUID) -> Self {
        Self { uuid }
    }

    public static var incrementing: Self {
        let counter = Counter()
        return Self { sequential(counter.next()) }
    }

    public static func sequential(_ value: UInt64) -> RFC_4122.UUID {
        RFC_4122.UUID(
            bytes: (
                0, 0, 0, 0,
                0, 0, 0, 0,
                UInt8(truncatingIfNeeded: value >> 56),
                UInt8(truncatingIfNeeded: value >> 48),
                UInt8(truncatingIfNeeded: value >> 40),
                UInt8(truncatingIfNeeded: value >> 32),
                UInt8(truncatingIfNeeded: value >> 24),
                UInt8(truncatingIfNeeded: value >> 16),
                UInt8(truncatingIfNeeded: value >> 8),
                UInt8(truncatingIfNeeded: value)
            )
        )
    }
}
