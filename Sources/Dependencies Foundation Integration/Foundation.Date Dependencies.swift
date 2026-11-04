import Dependencies
import Foundation
import FoundationEssentials_Extensions

extension Date {

    public init?(year: Int, month: Int, day: Int, hour: Int = 0, minute: Int = 0, second: Int = 0) {
        @Dependency(\.calendar) var calendar
        self.init(
            year: year,
            month: month,
            day: day,
            hour: hour,
            minute: minute,
            second: second,
            in: calendar
        )
    }
}

public func + (lhs: Date, rhs: DateComponents) -> Date {
    @Dependency(\.calendar) var calendar
    guard let result = lhs.adding(rhs, in: calendar) else {
        preconditionFailure("Adding date components \(rhs) to \(lhs) produced no date")
    }
    return result
}

public func - (lhs: Date, rhs: DateComponents) -> Date {
    @Dependency(\.calendar) var calendar
    guard let result = lhs.subtracting(rhs, in: calendar) else {
        preconditionFailure("Subtracting date components \(rhs) from \(lhs) produced no date")
    }
    return result
}

extension Date {

    public func adding(_ components: DateComponents) -> Date? {
        @Dependency(\.calendar) var calendar
        return adding(components, in: calendar)
    }

    public func subtracting(_ components: DateComponents) -> Date? {
        @Dependency(\.calendar) var calendar
        return subtracting(components, in: calendar)
    }
}

extension Date {

    public func isSameDay(as date: Date) -> Bool {
        @Dependency(\.calendar) var calendar
        return isSameDay(as: date, in: calendar)
    }

    public var isToday: Bool {
        @Dependency(\.calendar) var calendar
        return isToday(in: calendar)
    }

    public var isTomorrow: Bool {
        @Dependency(\.calendar) var calendar
        return isTomorrow(in: calendar)
    }

    public var isYesterday: Bool {
        @Dependency(\.calendar) var calendar
        return isYesterday(in: calendar)
    }

    public var isThisWeek: Bool {
        @Dependency(\.calendar) var calendar
        return isThisWeek(in: calendar)
    }

    public var isThisMonth: Bool {
        @Dependency(\.calendar) var calendar
        return isThisMonth(in: calendar)
    }

    public var isThisYear: Bool {
        @Dependency(\.calendar) var calendar
        return isThisYear(in: calendar)
    }
}

extension Date {

    public var era: Int {
        @Dependency(\.calendar) var calendar
        return era(in: calendar)
    }

    public var year: Int {
        @Dependency(\.calendar) var calendar
        return year(in: calendar)
    }

    public var month: Int {
        @Dependency(\.calendar) var calendar
        return month(in: calendar)
    }

    public var day: Int {
        @Dependency(\.calendar) var calendar
        return day(in: calendar)
    }

    public var hour: Int {
        @Dependency(\.calendar) var calendar
        return hour(in: calendar)
    }

    public var minute: Int {
        @Dependency(\.calendar) var calendar
        return minute(in: calendar)
    }

    public var second: Int {
        @Dependency(\.calendar) var calendar
        return second(in: calendar)
    }

    public var weekday: Int {
        @Dependency(\.calendar) var calendar
        return weekday(in: calendar)
    }

    public var weekdayOrdinal: Int {
        @Dependency(\.calendar) var calendar
        return weekdayOrdinal(in: calendar)
    }

    public var quarter: Int {
        @Dependency(\.calendar) var calendar
        return quarter(in: calendar)
    }

    public var weekOfMonth: Int {
        @Dependency(\.calendar) var calendar
        return weekOfMonth(in: calendar)
    }

    public var weekOfYear: Int {
        @Dependency(\.calendar) var calendar
        return weekOfYear(in: calendar)
    }

    public var yearForWeekOfYear: Int {
        @Dependency(\.calendar) var calendar
        return yearForWeekOfYear(in: calendar)
    }

    public var nanosecond: Int {
        @Dependency(\.calendar) var calendar
        return nanosecond(in: calendar)
    }

    public var calendarIdentifier: Calendar.Identifier {
        @Dependency(\.calendar) var calendar
        return calendar.identifier
    }

    public var timeZone: TimeZone {
        @Dependency(\.calendar) var calendar
        return calendar.timeZone
    }

    @available(macOS 14, iOS 17, tvOS 17, watchOS 10, *)
    public var isLeapMonth: Int {
        @Dependency(\.calendar) var calendar
        return isLeapMonth(in: calendar)
    }

    @available(macOS 15, iOS 18, tvOS 18, watchOS 11, *)
    public var dayOfYear: Int {
        @Dependency(\.calendar) var calendar
        return dayOfYear(in: calendar)
    }
}

extension Date {

    public var isWeekend: Bool {
        @Dependency(\.calendar) var calendar
        return isWeekend(in: calendar)
    }

    public var nextWeekday: Date? {
        @Dependency(\.calendar) var calendar
        return nextWeekday(in: calendar)
    }

    public func ifWeekendThenNextWorkday() -> Date? {
        @Dependency(\.calendar) var calendar
        return ifWeekendThenNextWorkday(in: calendar)
    }

    public func ifWeekendThenPreviousWorkday() -> Date? {
        @Dependency(\.calendar) var calendar
        return ifWeekendThenPreviousWorkday(in: calendar)
    }
}

extension Date {

    public func next(_ weekday: Int) -> Date? {
        @Dependency(\.calendar) var calendar
        return next(weekday, in: calendar)
    }

    public func previous(_ weekday: Int) -> Date? {
        @Dependency(\.calendar) var calendar
        return previous(weekday, in: calendar)
    }
}

extension Date {

    public func daysBetween(_ date: Date) -> Int? {
        @Dependency(\.calendar) var calendar
        return daysBetween(date, in: calendar)
    }

    public func addingBusinessDays(_ businessDays: Int) -> Date? {
        @Dependency(\.calendar) var calendar
        return addingBusinessDays(businessDays, in: calendar)
    }
}

extension Date {

    public var firstDayOfMonth: Date? {
        @Dependency(\.calendar) var calendar
        return firstDayOfMonth(in: calendar)
    }

    public var lastDayOfMonth: Date? {
        @Dependency(\.calendar) var calendar
        return lastDayOfMonth(in: calendar)
    }

    public var startOfDay: Date {
        @Dependency(\.calendar) var calendar
        return startOfDay(in: calendar)
    }

    public var endOfDay: Date? {
        @Dependency(\.calendar) var calendar
        return endOfDay(in: calendar)
    }

    public var startOfWeek: Date? {
        @Dependency(\.calendar) var calendar
        return startOfWeek(in: calendar)
    }

    public var endOfWeek: Date? {
        @Dependency(\.calendar) var calendar
        return endOfWeek(in: calendar)
    }

    public var startOfMonth: Date? {
        @Dependency(\.calendar) var calendar
        return startOfMonth(in: calendar)
    }

    public var endOfMonth: Date? {
        @Dependency(\.calendar) var calendar
        return endOfMonth(in: calendar)
    }

    public var startOfYear: Date? {
        @Dependency(\.calendar) var calendar
        return startOfYear(in: calendar)
    }

    public var endOfYear: Date? {
        @Dependency(\.calendar) var calendar
        return endOfYear(in: calendar)
    }
}

extension Date {

    public func age(at referenceDate: Date = Date()) -> Int? {
        @Dependency(\.calendar) var calendar
        return age(at: referenceDate, in: calendar)
    }

    public func timeAgoSince(_ date: Date = Date()) -> String {
        @Dependency(\.calendar) var calendar
        return timeAgoSince(date, in: calendar)
    }

    public func timeUntil(_ date: Date = Date()) -> String {
        @Dependency(\.calendar) var calendar
        return timeUntil(date, in: calendar)
    }

    public var relativeFormatted: String {
        @Dependency(\.calendar) var calendar
        return relativeFormatted(in: calendar)
    }
}
