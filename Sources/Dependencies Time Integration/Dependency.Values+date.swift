#if Time
public import Dependencies

extension __DependencyValues {

    public var date: __DependencyGenerator.Date {
        get { self[__DependencyGenerator.Date.self] }
        set { self[__DependencyGenerator.Date.self] = newValue }
    }
}
#endif
