public import Dependencies
public import Foundation

extension Calendar {
    public enum Key: Dependency.Key {
    }
}

extension Calendar.Key {
    public typealias Value = Calendar

    public static var liveValue: Calendar { .autoupdatingCurrent }
}

extension Dependency.Values {
    public var calendar: Calendar {
        get { self[Calendar.Key.self] }
        set { self[Calendar.Key.self] = newValue }
    }
}
