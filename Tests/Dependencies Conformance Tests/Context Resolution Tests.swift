import Dependencies
import Dependencies_Test_Support
import Testing

@Suite
struct `Context Resolution Tests` {

    @Test(arguments: [
        (Dependency<Never>.Context.Mode.live, "live greeting"),
        (Dependency<Never>.Context.Mode.test, "test greeting"),
        (Dependency<Never>.Context.Mode.preview, "preview greeting"),
    ])
    func `A fully specified key resolves the value of the context`(
        mode: Dependency<Never>.Context.Mode,
        expected: String
    ) {
        withDependencies(
            mode: mode,
            operation: {
                @Dependency(\.greeting) var greeting
                #expect(greeting == expected)
            }
        )
    }

    @Test
    func `A live only key serves its live value in every context`() {
        for mode in [Dependency<Never>.Context.Mode.live, .test, .preview] {
            withDependencies(
                mode: mode,
                operation: {
                    @Dependency(\.liveOnly) var liveOnly
                    #expect(liveOnly == "only live")
                }
            )
        }
    }

    @Test
    func `A test value defaults to the preview value`() {
        withDependencies(
            mode: .test,
            operation: {
                @Dependency(\.liveAndPreview) var value
                #expect(value == "preview half")
            }
        )
        withDependencies(
            mode: .live,
            operation: {
                @Dependency(\.liveAndPreview) var value
                #expect(value == "live half")
            }
        )
    }

    @Test
    func `A test only key serves its test value in previews`() {
        withDependencies(
            mode: .preview,
            operation: {
                @Dependency(\.testOnly) var testOnly
                #expect(testOnly == "only test")
            }
        )
    }

    @Test(arguments: [Dependency<Never>.Context.Mode.live, .test, .preview])
    func `The context is readable as a dependency value`(mode: Dependency<Never>.Context.Mode) {
        withDependencies(
            mode: mode,
            operation: {
                @Dependency(\.context) var context
                #expect(context == mode)
            }
        )
    }

    @Test
    func `Setting the context in the update closure selects that context`() {
        withDependencies {
            $0.context = .preview
        } operation: {
            @Dependency(\.context) var context
            @Dependency(\.greeting) var greeting
            #expect(context == .preview)
            #expect(greeting == "preview greeting")
        }
    }

    @Test
    func `Reads in the update closure follow a context set earlier in it`() {
        withDependencies {
            $0.context = .test
            $0.greeting += "!"
        } operation: {
            @Dependency(\.greeting) var greeting
            #expect(greeting == "test greeting!")
        }
    }

    @Test
    func `An explicit value wins over every context`() {
        for mode in [Dependency<Never>.Context.Mode.live, .test, .preview] {
            withDependencies {
                $0.context = mode
                $0.greeting = "explicit"
            } operation: {
                @Dependency(\.greeting) var greeting
                #expect(greeting == "explicit")
            }
        }
    }

    @Test
    func `Without a scope the context is live`() async {
        let context = await Task.detached {
            Dependency<Never>.Context.current.context
        }.value
        #expect(context == .live)
    }

    @Test(.dependencies)
    func `The dependencies trait enters the test context`() {
        @Dependency(\.context) var context
        @Dependency(\.greeting) var greeting
        #expect(context == .test)
        #expect(greeting == "test greeting")
    }
}
