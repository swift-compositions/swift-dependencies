import Dependencies
import Dependencies_Test_Support
import Testing

@Suite(.dependencies)
struct `Preparation Tests` {

    @Test
    func `A test root starts unprepared`() {
        @Dependency(\.greeting) var greeting
        #expect(greeting == "test greeting")
    }

    @Test
    func `A prepared value is read afterwards`() {
        prepareDependencies {
            $0.greeting = "prepared"
        }
        @Dependency(\.greeting) var greeting
        #expect(greeting == "prepared")
    }

    @Test
    func `Preparation returns the closure result`() {
        let result = prepareDependencies { values -> Int in
            values.number = 3
            return values.number * 2
        }
        #expect(result == 6)
    }

    @Test
    func `A scope override wins over a prepared value and restores it`() {
        prepareDependencies {
            $0.greeting = "prepared"
        }
        @Dependency(\.greeting) var greeting
        withDependencies {
            $0.greeting = "scoped"
        } operation: {
            #expect(greeting == "scoped")
        }
        #expect(greeting == "prepared")
    }

    @Test
    func `A scope entered after preparation sees the prepared values`() {
        prepareDependencies {
            $0.greeting = "prepared"
        }
        withDependencies {
            $0.number = 1
        } operation: {
            @Dependency(\.greeting) var greeting
            #expect(greeting == "prepared")
        }
    }

    @Test
    func `Successive preparations accumulate and the latest value wins`() {
        prepareDependencies {
            $0.greeting = "first"
            $0.number = 1
        }
        prepareDependencies {
            $0.greeting = "second"
        }
        @Dependency(\.greeting) var greeting
        @Dependency(\.number) var number
        #expect(greeting == "second")
        #expect(number == 1)
    }

    @Test
    func `The preparation closure reads earlier prepared values`() {
        prepareDependencies {
            $0.number = 20
        }
        prepareDependencies {
            $0.number += 22
        }
        @Dependency(\.number) var number
        #expect(number == 42)
    }

    @Test
    func `A child task sees prepared values`() async {
        prepareDependencies {
            $0.greeting = "prepared"
        }
        let value = await Task {
            Dependency<Never>.Context.current.greeting
        }.value
        #expect(value == "prepared")
    }

    @Test
    func `A throwing preparation propagates its error`() {
        #expect(throws: Failure.expected) {
            try prepareDependencies { _ -> Void in
                throw Failure.expected
            }
        }
    }
}
