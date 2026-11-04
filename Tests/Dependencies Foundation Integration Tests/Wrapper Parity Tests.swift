import Dependencies
import Dependencies_Foundation_Integration
import Dependencies_Test_Support
import Testing

@Suite(.dependency(\.calendar, Calendar(identifier: .gregorian)))
struct `Wrapper Parity Tests` {
    @Test func `the eight optional wrappers forward the explicit-calendar helper results`() throws {
        @Dependency(\.calendar) var calendar
        let saturday = try #require(Date(year: 2024, month: 1, day: 6))
        let birth = try #require(Date(year: 1990, month: 5, day: 15))

        #expect(saturday.nextWeekday == saturday.nextWeekday(in: calendar))
        #expect(saturday.ifWeekendThenNextWorkday() == saturday.ifWeekendThenNextWorkday(in: calendar))
        #expect(saturday.ifWeekendThenPreviousWorkday() == saturday.ifWeekendThenPreviousWorkday(in: calendar))
        #expect(saturday.daysBetween(birth) == saturday.daysBetween(birth, in: calendar))
        #expect(saturday.addingBusinessDays(3) == saturday.addingBusinessDays(3, in: calendar))
        #expect(saturday.firstDayOfMonth == saturday.firstDayOfMonth(in: calendar))
        #expect(saturday.lastDayOfMonth == saturday.lastDayOfMonth(in: calendar))
        #expect(birth.age(at: saturday) == birth.age(at: saturday, in: calendar))
    }
}
