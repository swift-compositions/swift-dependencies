import Dependencies
import Dependencies_Test_Support
import Testing

@Suite(.dependencies)
struct `Escaping Tests` {

    final class Model: Sendable {
        let continuation: Dependency<Never>.Continuation

        init() {
            self.continuation = withEscapedDependencies { $0 }
        }

        func greeting() -> String {
            continuation.yield {
                Dependency<Never>.Context.current.greeting
            }
        }
    }

    @Test
    func `A continuation restores the captured values after the scope has ended`() {
        let continuation = withDependencies {
            $0.greeting = "captured"
        } operation: {
            withEscapedDependencies { $0 }
        }
        let value = continuation.yield {
            Dependency<Never>.Context.current.greeting
        }
        #expect(value == "captured")
    }

    @Test
    func `A continuation replaces the values at the yield site`() {
        let continuation = withDependencies {
            $0.greeting = "captured"
        } operation: {
            withEscapedDependencies { $0 }
        }
        withDependencies {
            $0.greeting = "yield site"
            $0.number = 99
        } operation: {
            continuation.yield {
                @Dependency(\.greeting) var greeting
                @Dependency(\.number) var number
                #expect(greeting == "captured")
                #expect(number == 0)
            }
        }
    }

    @Test
    func `A continuation restores the captured context`() {
        let continuation = withDependencies(
            mode: .preview,
            operation: {
                withEscapedDependencies { $0 }
            }
        )
        let context = continuation.yield {
            Dependency<Never>.Context.current.context
        }
        #expect(context == .preview)
    }

    @Test
    func `A continuation is usable from an async yield`() async {
        let continuation = await withDependencies {
            $0.greeting = "async captured"
        } operation: {
            withEscapedDependencies { $0 }
        }
        let value = await continuation.yield {
            await Task.yield()
            return Dependency<Never>.Context.current.greeting
        }
        #expect(value == "async captured")
    }

    @Test
    func `An object keeps the dependencies it was created with`() {
        let model = withDependencies {
            $0.greeting = "model"
        } operation: {
            Model()
        }
        withDependencies {
            $0.greeting = "caller"
        } operation: {
            #expect(model.greeting() == "model")
        }
    }

    @Test
    func `An escaped continuation carries values into a later task`() async {
        let continuation = await withDependencies {
            $0.number = 5
        } operation: {
            withEscapedDependencies { $0 }
        }
        let value = await Task.detached {
            continuation.yield {
                Dependency<Never>.Context.current.number
            }
        }.value
        #expect(value == 5)
    }

    @Test
    func `The operation result of the escape is returned`() {
        let result = withEscapedDependencies { _ in 42 }
        #expect(result == 42)
    }
}
