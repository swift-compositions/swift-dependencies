import Dependencies
import Dependencies_Test_Support
import Testing

@Suite(.dependencies)
struct `Clock Tests` {

    @Test
    func `The default continuous clock sleeps`() async throws {
        @Dependency(\.continuousClock) var clock
        try await clock.sleep(for: .zero)
    }

    @Test
    func `An overriding clock receives the sleeps`() async throws {
        let sleeps = Recorder<Duration>()
        try await withDependencies {
            $0.continuousClock = RecordingClock(sleeps: sleeps)
        } operation: {
            @Dependency(\.continuousClock) var clock
            try await clock.sleep(for: .seconds(5))
            try await clock.sleep(for: .milliseconds(250))
        }
        #expect(sleeps.elements == [.seconds(5), .milliseconds(250)])
    }
}
