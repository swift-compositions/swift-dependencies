import Dependencies
import Foundation
import FoundationEssentials_Extensions

extension DateComponents {

    public static func + (lhs: DateComponents, rhs: DateComponents) -> DateComponents {
        @Dependency(\.calendar) var calendar
        return lhs.adding(rhs, in: calendar)
    }

    public static func - (lhs: DateComponents, rhs: DateComponents) -> DateComponents {
        @Dependency(\.calendar) var calendar
        return lhs.subtracting(rhs, in: calendar)
    }

    public static func * (lhs: DateComponents, rhs: Int) -> DateComponents {
        @Dependency(\.calendar) var calendar
        return lhs.multiplied(by: rhs, in: calendar)
    }

    public static func * (lhs: Int, rhs: DateComponents) -> DateComponents {
        return rhs * lhs
    }
}
