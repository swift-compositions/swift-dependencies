public import Witnesses
internal import Synchronization

extension __DependencyContext {

    public final class Root: Sendable {

        internal let values: Mutex<Witness.Values?>

        public init() {
            self.values = Mutex(nil)
        }
    }
}

extension __DependencyContext {

    @TaskLocal
    public static var root: Root = Root()
}
