#if Time
import Dependencies_Test_Support
import Dependencies_Time_Integration
import Testing

@Suite(.dependencies)
struct `Dependency.Generator.Date Tests` {

    @Test
    func `The test value is constant`() {
        @Dependency(\.date) var date
        let first = date.now
        let second = date()
        #expect(first == second)
    }

    @Test
    func `A chained key path reads now`() {
        @Dependency(\.date.now) var now
        @Dependency(\.date) var date
        #expect(now == date.now)
    }

    @Test
    func `A constant override is served`() {
        let instant = Time.Instant(secondsSinceUnixEpoch: 86_400)
        withDependencies {
            $0.date = .constant(instant)
        } operation: {
            @Dependency(\.date.now) var now
            #expect(now == instant)
        }
    }

    @Test
    func `A custom generator is called on every read`() {
        let seconds = Seconds()
        withDependencies {
            $0.date = Dependency<Never>.Generator.Date {
                Time.Instant(secondsSinceUnixEpoch: seconds.next())
            }
        } operation: {
            @Dependency(\.date) var date
            #expect(date.now.secondsSinceUnixEpoch == 1)
            #expect(date.now.secondsSinceUnixEpoch == 2)
        }
    }

    @Test
    func `A child task sees the same constant`() async {
        @Dependency(\.date) var date
        let expected = date.now
        let observed = await Task {
            Dependency<Never>.Context.current.date.now
        }.value
        #expect(observed == expected)
    }

    @Test
    func `The live value reads the system clock`() {
        withDependencies(mode: .live, operation: {
            @Dependency(\.date) var date
            let first = date.now
            let second = date.now
            #expect(first.secondsSinceUnixEpoch > 1_600_000_000)
            #expect(!(second < first))
        })
    }
}
#endif
