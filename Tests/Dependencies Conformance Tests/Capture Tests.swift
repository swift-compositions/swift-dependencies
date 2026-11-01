import Dependencies
import Dependencies_Test_Support
import Testing

@Suite(.dependencies)
struct `Capture Tests` {

    struct Greeter: Sendable {
        @Dependency(\.greeting) var greeting
    }

    @Test
    func `A dependency keeps the values in scope where it was created`() {
        let greeter = withDependencies {
            $0.greeting = "created"
        } operation: {
            Greeter()
        }
        #expect(greeter.greeting == "created")
    }

    @Test
    func `A scope at the read still wins over the values a dependency was created with`() {
        let greeter = withDependencies {
            $0.greeting = "created"
        } operation: {
            Greeter()
        }
        withDependencies {
            $0.greeting = "read"
        } operation: {
            #expect(greeter.greeting == "read")
        }
    }

    @Test
    func `A dependency created in a scope keeps it in a later task`() async {
        let greeter = withDependencies {
            $0.greeting = "created"
        } operation: {
            Greeter()
        }
        let value = await Task.detached { greeter.greeting }.value
        #expect(value == "created")
    }
}
