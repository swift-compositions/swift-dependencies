public import Witnesses
internal import Dependency
internal import Synchronization

nonisolated(nonsending)
    public func prepareDependencies<T, E: Swift.Error>(
        _ configure: (Witness.Preparation.Store) -> Void,
        operation: nonisolated(nonsending) () async throws(E) -> T
    ) async throws(E) -> T
{
    try await Witness.Preparation.with(configure, operation: operation)
}

public func prepareDependencies<T, E: Swift.Error>(
    _ configure: (Witness.Preparation.Store) -> Void,
    operation: () throws(E) -> T
) throws(E) -> T {
    try Witness.Preparation.with(configure, operation: operation)
}

public func prepareDependencies<R, E: Swift.Error>(
    _ update: (inout __DependencyValues) throws(E) -> R
) throws(E) -> R {
    let root = __DependencyContext.root
    var values = __DependencyValues(
        _witnessValues: root.values.withLock { $0 } ?? Witness.Values(),
        _l1Values: Dependency::Dependency.Scope.current
    )
    let result = try update(&values)
    root.values.withLock { prepared in
        prepared = (prepared ?? Witness.Values()).merging(values._witnessValues)
    }
    return result
}
