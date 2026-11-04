import Dependencies
import Dependencies_Foundation_Integration
import Dependencies_Test_Support
import Foundation
import Standard_Library_Extensions
import Testing

@Suite(
    .dependency(\.calendar, Calendar.current)
)
struct `Readme Verification` {

    @Test
    func `Quick Start: Date creation`() async throws {

        let date = Date(year: 2025, month: 7, day: 26)!
        let invalidDate = Date(year: 2025, month: 2, day: 30)

        #expect(date.year == 2025)
        #expect(date.month == 7)
        #expect(date.day == 26)
        #expect(invalidDate == nil)
    }

    @Test
    func `Quick Start: Date arithmetic`() async throws {
        let baseDate = Date(year: 2025, month: 1, day: 1)!

        let tomorrow = baseDate + 1.day
        let nextWeek = baseDate + 1.weekOfYear
        let complex = baseDate + 1.year + 6.months + 2.days

        #expect(tomorrow.day == 2)
        #expect(nextWeek.day == 8)
        #expect(complex.year == 2026)
        #expect(complex.month == 7)
    }

    @Test
    func `Quick Start: Date boundaries`() async throws {
        let date = Date(year: 2025, month: 7, day: 26, hour: 12)!

        let startOfDay = date.startOfDay
        let endOfMonth = try #require(date.endOfMonth)
        let startOfYear = try #require(date.startOfYear)
        #expect(startOfDay.hour == 0)
        #expect(startOfDay.minute == 0)
        #expect(endOfMonth.month == 8)
        #expect(endOfMonth.day == 1)
        #expect(date < endOfMonth)
        #expect(startOfYear.month == 1)
    }

    @Test
    func `Quick Start: State checks`() async throws {
        let today = Date()

        #expect(today.isToday == true)
    }

    @Test
    func `Quick Start: Relative formatting`() async throws {
        let now = Date()

        let pastDate = now - 2.hours
        let relativeString = pastDate.relativeFormatted
        @Dependency(\.calendar) var calendar
        let todayNoon = now.startOfDay + 12.hours
        let todayTen = now.startOfDay + 10.hours
        #expect(todayTen.relativeFormatted(in: calendar, now: todayNoon) == "2 hours ago")
        let previousDayNoon = todayNoon - 1.day
        #expect(previousDayNoon.relativeFormatted(in: calendar, now: todayNoon) == "yesterday")
        #expect(relativeString == (calendar.isDateInYesterday(pastDate) ? "yesterday" : pastDate.timeAgoSince(now, in: calendar)))

        let futureDate = now + 3.days
        let futureString = futureDate.relativeFormatted
        #expect(futureString.contains("day"))
    }

    @Test
    func `Quick Start: element access from Standard Library Extensions`() async throws {
        let array = [1, 2, 3]
        let value = array.element(at: 5)
        let validValue = array.element(at: 1)

        #expect(value == nil)
        #expect(validValue == 2)
    }

    @Test
    func `Usage: Date creation basic`() async throws {

        let date1 = Date(year: 2025, month: 7, day: 26)
        let date2 = Date(year: 2025, month: 12, day: 25, hour: 15, minute: 30, second: 45)

        #expect(date1 != nil)
        #expect(date2 != nil)
        #expect(date2?.hour == 15)
        #expect(date2?.minute == 30)
        #expect(date2?.second == 45)
    }

    @Test
    func `Usage: Date validation`() async throws {

        let invalid1 = Date(year: 2025, month: 13, day: 1)
        let invalid2 = Date(year: 2025, month: 2, day: 30)
        let invalid3 = Date(year: 2025, month: 1, day: 1, hour: 25)

        #expect(invalid1 == nil)
        #expect(invalid2 == nil)
        #expect(invalid3 == nil)
    }

    @Test
    func `Usage: Basic date arithmetic`() async throws {
        let date = Date(year: 2025, month: 2, day: 15)!

        let tomorrow = date + 1.day
        let lastWeek = date - 1.weekOfYear
        let nextMonth = date + 1.month

        #expect(tomorrow.day == 16)
        #expect(lastWeek.day == 8)
        #expect(nextMonth.month == 3)
    }

    @Test
    func `Usage: Safe date arithmetic`() async throws {
        let date = Date(year: 2025, month: 1, day: 15)!

        let safeResult = date.adding(1.day)
        let safeSubtract = date.subtracting(1.weekOfYear)

        #expect(safeResult != nil)
        #expect(safeSubtract != nil)
    }

    @Test
    func `Usage: Complex date calculations`() async throws {
        let date = Date(year: 2025, month: 1, day: 1, hour: 0)!

        let complex = date + 1.year + 6.months + 2.days + 3.hours + 30.minutes

        #expect(complex.year == 2026)
        #expect(complex.month == 7)
        #expect(complex.day == 3)
        #expect(complex.hour == 3)
        #expect(complex.minute == 30)
    }

    @Test
    func `Usage: Time components`() async throws {

        let _: DateComponents = 1.second
        let _: DateComponents = 30.seconds
        let _: DateComponents = 1.minute
        let _: DateComponents = 45.minutes
        let _: DateComponents = 1.hour
        let _: DateComponents = 12.hours
        let _: DateComponents = 1.day
        let _: DateComponents = 7.days
        let _: DateComponents = 1.month
        let _: DateComponents = 6.months
        let _: DateComponents = 1.year
        let _: DateComponents = 5.years

        #expect(1.day.day == 1)
        #expect(7.days.day == 7)
    }

    @Test
    func `Usage: Calendar components`() async throws {

        let _: DateComponents = 1.weekday
        let _: DateComponents = 1.quarter
        let _: DateComponents = 1.weekOfMonth
        let _: DateComponents = 1.weekOfYear
        let _: DateComponents = 1.weeksOfYear

        #expect(1.weekday.weekday == 1)
        #expect(1.quarter.quarter == 1)
    }

    @Test
    func `Usage: Day boundaries`() async throws {
        let date = Date(year: 2025, month: 7, day: 26, hour: 15, minute: 30)!

        let startOfDay = date.startOfDay
        let endOfDay = try #require(date.endOfDay)
        #expect(startOfDay.hour == 0)
        #expect(startOfDay.minute == 0)
        #expect(startOfDay.second == 0)
        #expect(endOfDay.day == 27)
        #expect(endOfDay.hour == 0)
        #expect(endOfDay.minute == 0)
        #expect(startOfDay <= date)
        #expect(date < endOfDay)
        #expect(!endOfDay.isSameDay(as: date))
    }

    @Test
    func `Usage: Week boundaries`() async throws {
        let date = Date(year: 2025, month: 7, day: 26)!

        let startOfWeek = try #require(date.startOfWeek)
        let endOfWeek = try #require(date.endOfWeek)
        #expect(startOfWeek <= date)
        #expect(endOfWeek >= date)
    }

    @Test
    func `Usage: Month boundaries`() async throws {
        let date = Date(year: 2025, month: 7, day: 26)!

        let startOfMonth = try #require(date.startOfMonth)
        let endOfMonth = try #require(date.endOfMonth)
        let firstDay = try #require(date.firstDayOfMonth)
        let lastDay = try #require(date.lastDayOfMonth)

        #expect(startOfMonth.day == 1)
        #expect(endOfMonth.month == 8)
        #expect(endOfMonth.day == 1)
        #expect(startOfMonth <= date)
        #expect(date < endOfMonth)
        #expect(firstDay.day == 1)
        #expect(lastDay.day == 31)
    }

    @Test
    func `Usage: Year boundaries`() async throws {
        let date = Date(year: 2025, month: 7, day: 26)!

        let startOfYear = try #require(date.startOfYear)
        let endOfYear = try #require(date.endOfYear)
        #expect(startOfYear.month == 1)
        #expect(startOfYear.day == 1)
        #expect(endOfYear.year == 2026)
        #expect(endOfYear.month == 1)
        #expect(endOfYear.day == 1)
        #expect(startOfYear <= date)
        #expect(date < endOfYear)
    }

    @Test
    func `Usage: Date state relative to today`() async throws {
        let date = Date()

        let isToday = date.isToday
        let isTomorrow = (date + 1.day).isTomorrow
        let isYesterday = (date - 1.day).isYesterday

        #expect(isToday == true)
        #expect(isTomorrow == true)
        #expect(isYesterday == true)
    }

    @Test
    func `Usage: Date state relative to current periods`() async throws {
        let date = Date()

        let isThisWeek = date.isThisWeek
        let isThisMonth = date.isThisMonth
        let isThisYear = date.isThisYear

        #expect(isThisWeek == true)
        #expect(isThisMonth == true)
        #expect(isThisYear == true)
    }

    @Test
    func `Usage: Weekend checks`() async throws {
        let saturday = Date(year: 2025, month: 8, day: 2)!

        let isWeekend = saturday.isWeekend

        #expect(isWeekend == true)
    }

    @Test
    func `Usage: Date comparisons`() async throws {
        let date1 = Date(year: 2025, month: 1, day: 1)!
        let date2 = date1 + 1.day

        let isAfter = date2.isAfter(date1)
        let isBefore = date1.isBefore(date2)
        let isSameDay = date1.isSameDay(as: date1)

        #expect(isAfter == true)
        #expect(isBefore == true)
        #expect(isSameDay == true)
    }

    @Test
    func `Usage: Weekend handling`() async throws {
        let saturday = Date(year: 2025, month: 8, day: 2)!

        if saturday.isWeekend {
            let nextWorkday = try #require(saturday.ifWeekendThenNextWorkday())
            let prevWorkday = try #require(saturday.ifWeekendThenPreviousWorkday())

            #expect(nextWorkday > saturday)
            #expect(prevWorkday < saturday)
        }
    }

    @Test
    func `Usage: Business day calculations`() async throws {
        let monday = Date(year: 2025, month: 7, day: 28)!

        let fiveBusinessDaysLater = try #require(monday.addingBusinessDays(5))
        let fiveBusinessDaysEarlier = try #require(monday.addingBusinessDays(-5))

        #expect(fiveBusinessDaysLater > monday)
        #expect(fiveBusinessDaysEarlier < monday)
    }

    @Test
    func `Usage: Weekday navigation`() async throws {
        let date = Date(year: 2025, month: 7, day: 26)!

        let nextMonday = try #require(date.next(2))
        let previousFriday = try #require(date.previous(6))

        #expect(nextMonday > date)
        #expect(previousFriday < date)
    }

    @Test
    func `Usage: Time calculations`() async throws {
        let startDate = Date(year: 2025, month: 1, day: 1)!
        let endDate = startDate + 10.days

        let daysBetween = try #require(startDate.daysBetween(endDate))

        #expect(daysBetween == 10)
    }

    @Test
    func `Usage: Age calculations`() async throws {
        let birthDate = Date(year: 2000, month: 1, day: 1)!
        let someDate = Date(year: 2025, month: 1, day: 1)!

        let ageAt = try #require(birthDate.age(at: someDate))

        #expect(ageAt == 25)
    }

    @Test
    func `Usage: Time Interval constants`() async throws {

        #expect(TimeInterval.minute == 60)
        #expect(TimeInterval.hour == 3600)
        #expect(TimeInterval.day == 86400)
        #expect(TimeInterval.week == 604800)
    }

    @Test
    func `Usage: Time Interval conversions`() async throws {

        let twoHours: TimeInterval = 2.hours
        let thirtyMinutes: TimeInterval = 30.minutes

        #expect(twoHours == 7200)
        #expect(thirtyMinutes == 1800)
    }

    @Test
    func `Usage: Time Interval as conversions`() async throws {

        let interval: TimeInterval = 7200
        let hours = interval.asHours
        let minutes = interval.asMinutes

        #expect(hours == 2.0)
        #expect(minutes == 120.0)
    }

    @Test
    func `Usage: Formatted duration`() async throws {

        let duration1 = (30.0).formattedDuration
        let duration2 = (90.0).formattedDuration
        let duration3 = (3660.0).formattedDuration
        let duration4 = (86500.0).formattedDuration

        #expect(duration1.contains("s"))
        #expect(duration2.contains("m"))
        #expect(duration3.contains("h"))
        #expect(duration4.contains("d"))
    }

    @Test
    func `Usage: Relative date formatting past`() async throws {
        let now = Date()

        let pastDate = now - 2.hours
        let timeAgo = pastDate.timeAgoSince(now)
        let relativeFormatted = pastDate.relativeFormatted

        #expect(timeAgo.contains("hour"))
        @Dependency(\.calendar) var calendar
        let todayNoon = now.startOfDay + 12.hours
        let todayTen = now.startOfDay + 10.hours
        #expect(todayTen.relativeFormatted(in: calendar, now: todayNoon) == "2 hours ago")
        let previousDayNoon = todayNoon - 1.day
        #expect(previousDayNoon.relativeFormatted(in: calendar, now: todayNoon) == "yesterday")
        #expect(relativeFormatted == (calendar.isDateInYesterday(pastDate) ? "yesterday" : pastDate.timeAgoSince(now, in: calendar)))
    }

    @Test
    func `Usage: Relative date formatting future`() async throws {
        let now = Date()

        let futureDate = now + 3.days
        let timeUntil = futureDate.timeUntil(now)
        let relativeFormatted = futureDate.relativeFormatted

        #expect(timeUntil.contains("day"))
        #expect(relativeFormatted.contains("day"))
    }

    @Test
    func `Usage: Relative date formatting special cases`() async throws {
        let now = Date()

        let yesterday = now - 1.day
        let yesterdayFormatted = yesterday.relativeFormatted

        let tomorrow = now + 1.day
        let tomorrowFormatted = tomorrow.relativeFormatted

        #expect(yesterdayFormatted == "yesterday" || yesterdayFormatted.contains("hour"))
        #expect(tomorrowFormatted == "tomorrow" || tomorrowFormatted.contains("hour"))
    }

    @Test
    func `Usage: Basic date components`() async throws {
        let date = Date(year: 2025, month: 7, day: 26, hour: 15, minute: 30)!

        #expect(date.year == 2025)
        #expect(date.month == 7)
        #expect(date.day == 26)
        #expect(date.hour == 15)
        #expect(date.minute == 30)
        #expect(date.second == 0)
    }

    @Test
    func `Usage: Advanced date components`() async throws {
        let date = Date(year: 2025, month: 7, day: 26)!

        let weekday = date.weekday
        let weekOfYear = date.weekOfYear
        let weekOfMonth = date.weekOfMonth
        let quarter = date.quarter
        let era = date.era

        #expect(weekday >= 1 && weekday <= 7)
        #expect(weekOfYear > 0)
        #expect(weekOfMonth > 0)
        #expect(quarter >= 1 && quarter <= 4)
        #expect(era >= 0)
    }

    @Test
    func `Usage: Calendar and timezone info`() async throws {
        let date = Date(year: 2025, month: 7, day: 26)!

        let calendarIdentifier = date.calendarIdentifier
        let timeZone = date.timeZone

        #expect(calendarIdentifier == Calendar.current.identifier)
        #expect(timeZone == Calendar.current.timeZone)
    }

    @Test
    func `Usage: Date Components combining`() async throws {

        let components = 1.day + 2.hours + 30.minutes
        let result = Date(year: 2025, month: 1, day: 1)! + components

        #expect(result.day == 2)
        #expect(result.hour == 2)
        #expect(result.minute == 30)
    }

    @Test
    func `Usage: Date Components multiplication`() async throws {

        let threeDays = 1.day * 3
        let sixMonths = 1.month * 6

        #expect(threeDays.day == 3)
        #expect(sixMonths.month == 6)
    }

    @Test
    func `Usage: Date Components subtraction`() async throws {

        let difference = 2.weeksOfYear - 3.days

        #expect(difference.weekOfYear == 1)
        #expect(difference.day == 4)
    }

    @Test
    func `Usage: Date Components negation`() async throws {
        let components = 1.day + 2.hours

        let negated = components.negated()

        #expect(negated.day == -1)
        #expect(negated.hour == -2)
    }

    @Test
    func `Usage: Date Components basic validation`() async throws {
        let components = DateComponents(year: 2025, month: 7, day: 26)

        let isValid = components.isValid

        #expect(isValid == true)
    }

    @Test
    func `Usage: Date Components calendar validation`() async throws {
        let components = DateComponents(year: 2025, month: 7, day: 26)

        let calendar = Calendar.current
        let isValid = components.isValid(for: calendar)

        #expect(isValid == true)
    }

    @Test
    func `Usage: Date Components invalid examples`() async throws {

        let invalid = DateComponents(month: 13, day: 1)
        let isValid = invalid.isValid

        #expect(isValid == false)
    }

    @Test
    func `Usage: date format style`() async throws {

        let dateString = Date(year: 2025, month: 7, day: 26)!.formatted(.dateFormat("yyyy-MM-dd"))

        #expect(dateString == "2025-07-26")
    }

    @Test
    func `Usage: Format Style extensions`() async throws {

        let date = Date(year: 2025, month: 7, day: 26)!
        let formatted = date.formatted(.dateFormat("MMM d, yyyy"))

        #expect(formatted.contains("2025"))
    }
}
