import Dependencies
import Dependencies_Test_Support
import Testing

@Suite(.dependencies)
struct `Scoping Tests` {

    @Test
    func `A nested scope overrides and then restores the outer value`() {
        @Dependency(\.greeting) var greeting
        withDependencies {
            $0.greeting = "outer"
        } operation: {
            #expect(greeting == "outer")
            withDependencies {
                $0.greeting = "inner"
            } operation: {
                #expect(greeting == "inner")
            }
            #expect(greeting == "outer")
        }
        #expect(greeting == "test greeting")
    }

    @Test
    func `A nested scope keeps the outer overrides of other keys`() {
        withDependencies {
            $0.greeting = "kept"
            $0.number = 1
        } operation: {
            withDependencies {
                $0.number = 2
            } operation: {
                @Dependency(\.greeting) var greeting
                @Dependency(\.number) var number
                #expect(greeting == "kept")
                #expect(number == 2)
            }
        }
    }

    @Test
    func `Sibling scopes do not see each other`() {
        @Dependency(\.number) var number
        withDependencies {
            $0.number = 1
        } operation: {
            #expect(number == 1)
        }
        withDependencies { _ in
        } operation: {
            #expect(number == 0)
        }
    }

    @Test
    func `A scope is restored after its operation throws`() {
        @Dependency(\.greeting) var greeting
        withDependencies {
            $0.greeting = "outer"
        } operation: {
            #expect(throws: Failure.expected) {
                try withDependencies {
                    $0.greeting = "inner"
                } operation: {
                    throw Failure.expected
                }
            }
            #expect(greeting == "outer")
        }
    }

    @Test
    func `A typed error passes through unchanged`() {
        func fail() throws(Failure) -> Int {
            throw .expected
        }
        #expect(throws: Failure.expected) {
            try withDependencies {
                $0.number = 1
            } operation: {
                try fail()
            }
        }
    }

    @Test
    func `The operation result is returned`() {
        let result = withDependencies {
            $0.number = 7
        } operation: {
            Dependency<Never>.Context.current.number * 6
        }
        #expect(result == 42)
    }

    @Test
    func `Nested async scopes override and restore across suspension points`() async {
        @Dependency(\.greeting) var greeting
        await withDependencies {
            $0.greeting = "outer"
        } operation: {
            await Task.yield()
            await withDependencies {
                $0.greeting = "inner"
            } operation: {
                await Task.yield()
                #expect(greeting == "inner")
            }
            await Task.yield()
            #expect(greeting == "outer")
        }
        #expect(greeting == "test greeting")
    }

    @Test
    func `A mode scope keeps explicit overrides from the enclosing scope`() {
        withDependencies {
            $0.greeting = "explicit"
        } operation: {
            withDependencies(mode: .preview, operation: {
                @Dependency(\.greeting) var greeting
                @Dependency(\.context) var context
                #expect(greeting == "explicit")
                #expect(context == .preview)
            })
        }
    }
}
