import Dependencies
import Dependencies_Test_Support
import Testing

@Suite(.dependencies)
struct `Key Path Access Tests` {

    @Test
    func `A key path property wrapper reads the key's value`() {
        @Dependency(\.greeting) var greeting
        #expect(greeting == "test greeting")
    }

    @Test
    func `A write through a key path is visible inside the operation`() {
        withDependencies {
            $0.greeting = "written"
        } operation: {
            @Dependency(\.greeting) var greeting
            #expect(greeting == "written")
        }
    }

    @Test
    func `The update closure reads back its own writes`() {
        withDependencies {
            $0.number = 20
            $0.number += 1
            $0.number *= 2
        } operation: {
            @Dependency(\.number) var number
            #expect(number == 42)
        }
    }

    @Test
    func `The update closure starts from the enclosing values`() {
        withDependencies {
            $0.greeting = "enclosing"
        } operation: {
            withDependencies {
                $0.greeting += " and nested"
            } operation: {
                @Dependency(\.greeting) var greeting
                #expect(greeting == "enclosing and nested")
            }
        }
    }

    @Test
    func `Type form and key path form resolve the same value`() {
        withDependencies {
            $0.greeting = "shared"
        } operation: {
            @Dependency(GreetingKey.self) var byType
            @Dependency(\.greeting) var byKeyPath
            #expect(byType == byKeyPath)
            #expect(byType == "shared")
        }
    }

    @Test
    func `A chained key path reads a member of the value`() {
        withDependencies {
            $0.greeting = "12345"
        } operation: {
            @Dependency(\.greeting.count) var length
            #expect(length == 5)
        }
    }

    @Test
    func `The subscript and the key path address the same storage`() {
        withDependencies {
            $0[GreetingKey.self] = "via subscript"
        } operation: {
            #expect(Dependency<Never>.Context.current.greeting == "via subscript")
        }
    }

    @Test
    func `A throwing update closure propagates its error and runs no operation`() {
        let ran = Recorder<Bool>()
        #expect(throws: Failure.expected) {
            try withDependencies {
                $0.greeting = "never used"
                throw Failure.expected
            } operation: {
                ran.append(true)
            }
        }
        #expect(ran.elements.isEmpty)
    }
}
