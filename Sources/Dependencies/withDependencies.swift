public import Witnesses

@inlinable
public func withDependencies<T, E: Swift.Error>(
    _ update: (inout __DependencyValues) throws(E) -> Void,
    operation: () throws(E) -> T
) throws(E) -> T {
    var values = __DependencyContext.current
    try update(&values)
    return try values._scope(operation)
}

@inlinable
nonisolated(nonsending)
    public func withDependencies<T, E: Swift.Error>(
        _ update: (inout __DependencyValues) throws(E) -> Void,
        operation: nonisolated(nonsending) () async throws(E) -> T
    ) async throws(E) -> T
{
    var values = __DependencyContext.current
    try update(&values)
    return try await values._scope(operation)
}

@inlinable
public func withDependencies<T, E: Swift.Error>(
    mode: __DependencyContext.Mode,
    _ modify: ((inout __DependencyValues) -> Void)? = nil,
    operation: () throws(E) -> T
) throws(E) -> T {
    var values = __DependencyContext.current
    values._mode = mode
    modify?(&values)
    return try values._scope(operation)
}

@inlinable
nonisolated(nonsending)
    public func withDependencies<T, E: Swift.Error>(
        mode: __DependencyContext.Mode,
        _ modify: ((inout __DependencyValues) -> Void)? = nil,
        operation: nonisolated(nonsending) () async throws(E) -> T
    ) async throws(E) -> T
{
    var values = __DependencyContext.current
    values._mode = mode
    modify?(&values)
    return try await values._scope(operation)
}
