public import Witnesses

@inlinable
public func withEscapedDependencies<R, E: Swift.Error>(
    _ operation: (Witness.Context.Escaped) throws(E) -> R
) throws(E) -> R {
    try Witness.Context.withEscaped(operation)
}

@inlinable
public func withEscapedDependencies<R, E: Swift.Error>(
    _ operation: (Witness.Context.Escaped) async throws(E) -> R
) async throws(E) -> R {
    try await Witness.Context.withEscaped(operation)
}
