public import Dependencies

extension __DependencyValues {

    public var uuid: __DependencyGenerator.UUID {
        get { self[__DependencyGenerator.UUID.self] }
        set { self[__DependencyGenerator.UUID.self] = newValue }
    }
}
