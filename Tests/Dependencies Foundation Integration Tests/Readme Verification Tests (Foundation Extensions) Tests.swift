import Dependencies
import Dependencies_Foundation_Integration
import Dependencies_Test_Support
import Foundation
import Standard_Library_Extensions
import Testing

@Suite(.dependency(\.calendar, Calendar.current))
struct `Readme Verification (Foundation Extensions)` {

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

        let tomorrow = Date() + 1.day
        let nextWeek = Date() + 1.weekOfYear
        let complex = Date() + 1.year + 6.months + 2.days

        #expect(tomorrow > Date())
        #expect(nextWeek > Date())
        #expect(complex > Date())
    }

    @Test
    func `Quick Start: Date boundaries`() async throws {

        let startOfDay = Date().startOfDay
        let endOfMonth = try #require(Date().endOfMonth)
        let startOfYear = try #require(Date().startOfYear)
        #expect(startOfDay.hour == 0)
        #expect(startOfDay.minute == 0)
        #expect(endOfMonth > Date())
        #expect(startOfYear <= Date())
    }

    @Test
    func `Quick Start: State checks`() async throws {

        if Date().isToday {

        }
        #expect(Date().isToday == true)
    }

    @Test
    func `Quick Start: Relative formatting`() async throws {

        let now = Date()
        let pastDate = now - 2.hours
        let pastFormatted = pastDate.relativeFormatted

        let futureDate = Date() + 3.days
        let futureFormatted = futureDate.relativeFormatted

        @Dependency(\.calendar) var calendar
        let todayNoon = now.startOfDay + 12.hours
        let todayTen = now.startOfDay + 10.hours
        #expect(todayTen.relativeFormatted(in: calendar, now: todayNoon) == "2 hours ago")
        let previousDayNoon = todayNoon - 1.day
        #expect(previousDayNoon.relativeFormatted(in: calendar, now: todayNoon) == "yesterday")
        #expect(pastFormatted == (calendar.isDateInYesterday(pastDate) ? "yesterday" : pastDate.timeAgoSince(now, in: calendar)))
        #expect(futureFormatted.contains("day") || futureFormatted.contains("in"))
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

        let date = Date()
        let tomorrow = date + 1.day
        let lastWeek = date - 1.weekOfYear
        let nextMonth = date + 1.month

        #expect(tomorrow > date)
        #expect(lastWeek < date)
        #expect(nextMonth > date)
    }

    @Test
    func `Usage: Safe date arithmetic`() async throws {

        let date = Date()
        let safeResult = date.adding(1.day)
        let safeSubtract = date.subtracting(1.weekOfYear)

        #expect(safeResult != nil)
        #expect(safeSubtract != nil)
    }

    @Test
    func `Usage: Complex date calculations`() async throws {

        let date = Date()
        let complex = date + 1.year + 6.months + 2.days + 3.hours + 30.minutes

        #expect(complex > date)
    }

    @Test
    func `Usage: Time components`() async throws {

        let _ = 1.second
        let _ = 30.seconds
        let _ = 1.minute
        let _ = 45.minutes
        let _ = 1.hour
        let _ = 12.hours
        let _ = 1.day
        let _ = 7.days
        let _ = 1.month
        let _ = 6.months
        let _ = 1.year
        let _ = 5.years
    }

    @Test
    func `Usage: Calendar components`() async throws {

        let _ = 1.weekday
        let _ = 1.quarter
        let _ = 1.weekOfMonth
        let _ = 1.weekOfYear
        let _ = 1.weeksOfYear
    }

    @Test
    func `Usage: Day boundaries`() async throws {

        let date = Date()

        let startOfDay = date.startOfDay
        let endOfDay = try #require(date.endOfDay)
        #expect(startOfDay.hour == 0)
        #expect(startOfDay.minute == 0)
        #expect(endOfDay > startOfDay)
    }

    @Test
    func `Usage: Week boundaries`() async throws {

        let date = Date()
        let startOfWeek = try #require(date.startOfWeek)
        let endOfWeek = try #require(date.endOfWeek)
        #expect(startOfWeek <= date)
        #expect(endOfWeek >= date)
    }

    @Test
    func `Usage: Month boundaries`() async throws {

        let date = Date()
        let startOfMonth = try #require(date.startOfMonth)
        let endOfMonth = try #require(date.endOfMonth)
        let firstDay = try #require(date.firstDayOfMonth)
        let lastDay = try #require(date.lastDayOfMonth)

        #expect(startOfMonth <= date)
        #expect(endOfMonth >= date)
        #expect(firstDay.day == 1)
        #expect(lastDay.day > 0)
    }

    @Test
    func `Usage: Year boundaries`() async throws {

        let date = Date()
        let startOfYear = try #require(date.startOfYear)
        let endOfYear = try #require(date.endOfYear)
        #expect(startOfYear <= date)
        #expect(endOfYear >= date)
        #expect(startOfYear.month == 1)
        #expect(startOfYear.day == 1)
    }

    @Test
    func `Usage: Date state relative to today`() async throws {

        let date = Date()

        _ = date.isToday
        _ = date.isTomorrow
        _ = date.isYesterday

        #expect(date.isToday == true)
    }

    @Test
    func `Usage: Date state relative to current periods`() async throws {

        let date = Date()
        _ = date.isThisWeek
        _ = date.isThisMonth
        _ = date.isThisYear

        _ = date.isWeekend

        #expect(date.isThisYear == true)
    }

    @Test
    func `Usage: Date comparisons`() async throws {

        let date1 = Date()
        let date2 = Date() + 1.day

        #expect(date2.isAfter(date1) == true)
        #expect(date1.isBefore(date2) == true)
        #expect(date1.isSameDay(as: date1) == true)
    }

    @Test
    func `Usage: Weekend checks`() async throws {

        let date = Date()

        if date.isWeekend {
            let nextWorkday = try #require(date.ifWeekendThenNextWorkday())
            let prevWorkday = try #require(date.ifWeekendThenPreviousWorkday())

            #expect(!nextWorkday.isWeekend)
            #expect(!prevWorkday.isWeekend)
        }

        let nextWeekday = try #require(date.nextWeekday)
        #expect(!nextWeekday.isWeekend)
    }

    @Test
    func `Usage: Business day calculations`() async throws {

        let date = Date()
        let fiveBusinessDaysLater = try #require(date.addingBusinessDays(5))
        let fiveBusinessDaysEarlier = try #require(date.addingBusinessDays(-5))

        #expect(fiveBusinessDaysLater > date)
        #expect(fiveBusinessDaysEarlier < date)
    }

    @Test
    func `Usage: Weekday navigation`() async throws {

        let date = Date()

        let nextMonday = try #require(date.next(2))
        let previousFriday = try #require(date.previous(6))

        #expect(nextMonday.weekday == 2)
        #expect(previousFriday.weekday == 6)
    }

    @Test
    func `Usage: Time calculations`() async throws {

        let startDate = Date()
        let endDate = Date() + 10.days

        let daysBetween = try #require(startDate.daysBetween(endDate))

        #expect(daysBetween == 10)
    }

    @Test
    func `Usage: Age calculations`() async throws {

        let birthDate = Date(year: 2000, month: 1, day: 1)!
        let age = try #require(birthDate.age())
        let ageAt = try #require(birthDate.age(at: Date(year: 2025, month: 1, day: 1)!))

        #expect(age > 20)
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
        #expect(interval.asHours == 2.0)
        #expect(interval.asMinutes == 120.0)
        #expect(interval.asDays < 1.0)
    }

    @Test
    func `Usage: Formatted duration`() async throws {

        #expect((30.0).formattedDuration == "30s")
        #expect((90.0).formattedDuration == "2m")
        #expect((3660.0).formattedDuration == "1.0h")
        #expect((86500.0).formattedDuration == "1.0d")
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

        #expect(timeUntil.contains("in"))
        #expect(relativeFormatted.contains("day") || relativeFormatted.contains("in"))
    }

    @Test
    func `Usage: Relative date formatting special cases`() async throws {

        let now = Date()

        let yesterday = now - 1.day
        let yesterdayFormatted = yesterday.relativeFormatted

        let tomorrow = now + 1.day
        let tomorrowFormatted = tomorrow.relativeFormatted

        let recent = now - 5.seconds
        let recentFormatted = recent.relativeFormatted

        #expect(!yesterdayFormatted.isEmpty)
        #expect(!tomorrowFormatted.isEmpty)
        #expect(!recentFormatted.isEmpty)
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

        let date = Date(year: 2025, month: 7, day: 26, hour: 15, minute: 30)!

        _ = date.weekday
        _ = date.weekOfYear
        _ = date.weekOfMonth
        _ = date.quarter
        _ = date.era

        #expect(date.weekday >= 1 && date.weekday <= 7)
        #expect(date.quarter >= 1 && date.quarter <= 4)
    }

    @Test
    func `Usage: Calendar and timezone info`() async throws {

        let date = Date(year: 2025, month: 7, day: 26, hour: 15, minute: 30)!

        _ = date.calendarIdentifier
        _ = date.timeZone

        #expect(date.calendarIdentifier == Calendar.current.identifier)
    }

    @Test
    func `Usage: Date Components combining`() async throws {

        let components = 1.day + 2.hours + 30.minutes
        let result = Date() + components

        #expect(result > Date())
    }

    @Test
    func `Usage: Date Components multiplication`() async throws {

        let threeDays = 1.day * 3
        let sixMonths = 1.month * 6

        let date = Date()
        let result1 = date + threeDays
        let result2 = date + sixMonths

        #expect(result1 > date)
        #expect(result2 > date)
    }

    @Test
    func `Usage: Date Components subtraction`() async throws {

        let difference = 2.weeksOfYear - 3.days

        let date = Date()
        let result = date + difference

        #expect(result != date)
    }

    @Test
    func `Usage: Date Components basic validation`() async throws {

        let components = DateComponents(year: 2025, month: 7, day: 26)

        #expect(components.isValid == true)
    }

    @Test
    func `Usage: Date Components calendar validation`() async throws {

        let components = DateComponents(year: 2025, month: 7, day: 26)
        let calendar = Calendar.current

        #expect(components.isValid(for: calendar) == true)
    }

    @Test
    func `Usage: Date Components invalid examples`() async throws {

        let invalid = DateComponents(month: 13, day: 1)

        #expect(invalid.isValid == false)
    }

    @Test
    func `Usage: date format style`() async throws {

        let dateString = Date().formatted(.dateFormat("yyyy-MM-dd"))

        #expect(dateString.count == 10)
        #expect(dateString.contains("-"))
    }

    @Test
    func `Usage: Format Style extensions`() async throws {

        let formatted = Date().formatted(.dateFormat("MMM d, yyyy"))

        #expect(!formatted.isEmpty)
        #expect(formatted.contains(","))
    }
}
