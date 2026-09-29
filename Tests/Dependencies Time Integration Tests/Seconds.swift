import Synchronization

final class Seconds: Sendable {
    private let value = Atomic<Int64>(0)

    func next() -> Int64 {
        value.wrappingAdd(1, ordering: .relaxed).newValue
    }
}
