public import Witnesses

extension __DependencyValues {

    public var context: Witness.Context.Mode {
        get { _mode ?? Witness.Context.currentMode }
        set { _mode = newValue }
    }
}
