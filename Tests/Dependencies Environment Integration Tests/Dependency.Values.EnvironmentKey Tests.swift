import Dependencies_Environment_Integration
import Dependencies_Test_Support
import Environment
import Testing

@Suite
struct `Dependency.Values.EnvironmentKey Tests` {
    @Test
    func `the live environment is the process's effective environment`() {
        @Dependency({ $0.environment }) var environment
        #expect(environment == Environment.Snapshot.effective())
    }

    @Test(.dependencies { _ in })
    func `a test starts from an empty environment`() {
        @Dependency({ $0.environment }) var environment
        #expect(environment == Environment.Snapshot())
    }

    @Test(.dependencies { $0.environment = Environment.Snapshot(["PORT": "8080"]) })
    func `a test sets the variables it needs`() {
        @Dependency({ $0.environment }) var environment
        #expect(environment.int("PORT") == 8080)
    }
}
