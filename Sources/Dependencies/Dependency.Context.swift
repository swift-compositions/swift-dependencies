import Dependency
internal import Synchronization
internal import Environment
public import Witnesses

public enum __DependencyContext: Sendable {}

extension __DependencyContext {

    public typealias Mode = Witness.Context.Mode

    public static var mode: Mode {
        Witness.Context.currentMode
    }

    public static var current: __DependencyValues {
        let scoped = Witness.Context.current
        let prepared = root.values.withLock { $0 }
        return __DependencyValues(
            _witnessValues: prepared.map { $0.merging(scoped) } ?? scoped,
            _l1Values: Dependency.Dependency.Scope.current
        )
    }

    public static func detect() -> Mode {
        if Environment.task.isSet("XCODE_RUNNING_FOR_PREVIEWS") {
            return .preview
        }
        if Environment.task.isSet("XCTestConfigurationFilePath") {
            return .test
        }
        if Environment.task.isSet("SWIFT_TESTING") {
            return .test
        }
        return .live
    }
}
