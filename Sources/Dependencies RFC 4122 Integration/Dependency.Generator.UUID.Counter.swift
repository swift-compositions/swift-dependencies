#if RFC4122
internal import Dependencies
internal import Synchronization

extension __DependencyGenerator.UUID {

    internal final class Counter: Sendable {

        private let value = Atomic<UInt64>(0)

        internal func next() -> UInt64 {
            value.wrappingAdd(1, ordering: .relaxed).oldValue
        }
    }
}
#endif
