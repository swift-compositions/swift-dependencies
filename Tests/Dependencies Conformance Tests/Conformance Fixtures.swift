import Dependencies
import Synchronization

enum GreetingKey: Dependency.Key {
    static var liveValue: String { "live greeting" }
    static var testValue: String { "test greeting" }
    static var previewValue: String { "preview greeting" }
}

extension Dependency.Values {
    var greeting: String {
        get { self[GreetingKey.self] }
        set { self[GreetingKey.self] = newValue }
    }
}

enum LiveOnlyKey: Dependency.Key {
    typealias Value = String
    static var liveValue: String { "only live" }
}

extension Dependency.Values {
    var liveOnly: String {
        get { self[LiveOnlyKey.self] }
        set { self[LiveOnlyKey.self] = newValue }
    }
}

enum LiveAndPreviewKey: Dependency.Key {
    static var liveValue: String { "live half" }
    static var previewValue: String { "preview half" }
}

extension Dependency.Values {
    var liveAndPreview: String {
        get { self[LiveAndPreviewKey.self] }
        set { self[LiveAndPreviewKey.self] = newValue }
    }
}

enum TestOnlyKey: Witness.Key.Test {
    static var testValue: String { "only test" }
}

extension Dependency.Values {
    var testOnly: String {
        get { self[TestOnlyKey.self] }
        set { self[TestOnlyKey.self] = newValue }
    }
}

enum NumberKey: Dependency.Key {
    typealias Value = Int
    static var liveValue: Int { 0 }
}

extension Dependency.Values {
    var number: Int {
        get { self[NumberKey.self] }
        set { self[NumberKey.self] = newValue }
    }
}

enum Failure: Swift.Error, Equatable {
    case expected
}

final class Recorder<Element: Sendable>: Sendable {
    private let storage = Mutex<[Element]>([])

    func append(_ element: Element) {
        storage.withLock { $0.append(element) }
    }

    var elements: [Element] {
        storage.withLock { $0 }
    }
}

struct RecordingClock: Clock {
    struct Instant: InstantProtocol {
        var offset: Duration

        func advanced(by duration: Duration) -> Self {
            Self(offset: offset + duration)
        }

        func duration(to other: Self) -> Duration {
            other.offset - offset
        }

        static func < (lhs: Self, rhs: Self) -> Bool {
            lhs.offset < rhs.offset
        }
    }

    let sleeps: Recorder<Duration>

    var now: Instant { Instant(offset: .zero) }

    var minimumResolution: Duration { .zero }

    func sleep(until deadline: Instant, tolerance: Duration?) async throws {
        sleeps.append(deadline.offset)
    }
}
