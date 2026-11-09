import Dependencies
import Dependencies_Foundation_Integration
import Dependencies_Test_Support
import Foundation
import Testing

enum `Date Tests` {}

extension `Date Tests` {
    @Suite(.dependency(\.calendar, Calendar.current))
    struct Test {
        @Suite struct Unit {}
        @Suite struct `Edge Case` {}
    }
}

extension `Date Tests`.Test.Unit {

    @Test
    func `next returns the next occurrence for a valid weekday`() throws {
        let monday = try #require(Date(year: 2025, month: 7, day: 28))
        let nextWednesday = try #require(monday.next(4))
        #expect(nextWednesday.weekday == 4)
        #expect(nextWednesday > monday)
    }

    @Test
    func `previous returns the previous occurrence for a valid weekday`() throws {
        let friday = try #require(Date(year: 2025, month: 7, day: 25))
        let previousWednesday = try #require(friday.previous(4))
        #expect(previousWednesday.weekday == 4)
        #expect(previousWednesday < friday)
    }
}

extension `Date Tests`.Test.`Edge Case` {

    @Test
    func `next returns nil for weekday values outside 1 through 7`() throws {
        let date = try #require(Date(year: 2025, month: 7, day: 25))
        #expect(date.next(0) == nil)
        #expect(date.next(8) == nil)
        #expect(date.next(-1) == nil)
    }

    @Test
    func `previous returns nil for weekday values outside 1 through 7`() throws {
        let date = try #require(Date(year: 2025, month: 7, day: 25))
        #expect(date.previous(0) == nil)
        #expect(date.previous(8) == nil)
        #expect(date.previous(-1) == nil)
    }
}

extension `Date Tests`.Test.Unit {

    @Test
    func `adding date components with + matches adding(_:)`() throws {
        let january31 = try #require(Date(year: 2025, month: 1, day: 31))
        let sum: Date? = january31 + 1.month
        #expect(sum == january31.adding(1.month))
        #expect(sum != nil)
    }

    @Test
    func `subtracting date components with - matches subtracting(_:)`() throws {
        let march31 = try #require(Date(year: 2025, month: 3, day: 31))
        let difference: Date? = march31 - 1.month
        #expect(difference == march31.subtracting(1.month))
        #expect(difference != nil)
    }
}
