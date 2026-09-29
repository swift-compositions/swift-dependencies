public import Dependency
public import Witnesses

public struct __DependencyValues: Sendable {

    public var _witnessValues: Witness.Values

    public var _l1Values: Dependency::Dependency.Values

    public var _mode: Witness.Context.Mode?

    @inlinable
    public init(
        _witnessValues: Witness.Values = Witness.Values(),
        _l1Values: Dependency::Dependency.Values = .init(),
        _mode: Witness.Context.Mode? = nil
    ) {
        self._witnessValues = _witnessValues
        self._l1Values = _l1Values
        self._mode = _mode
    }
}

extension __DependencyValues {

    @inlinable
    public subscript<K: Witness.Key>(key: K.Type) -> K.Value
    where K.Value: Copyable & Escapable {
        get { _scope { Witness.Context[key] } }
        set { _witnessValues[key] = newValue }
    }
}

extension __DependencyValues {

    @inlinable
    public subscript<K: Witness.Key.Test>(key: K.Type) -> K.Value
    where K.Value: Copyable & Escapable {
        get { _scope { Witness.Context[key] } }
        set { _witnessValues[key] = newValue }
    }
}

extension __DependencyValues {

    @inlinable
    public subscript<K: __DependencyKey>(key: K.Type) -> K.Value
    where K.Value: Copyable & Escapable {
        get {
            var l1Values = _l1Values
            if let _mode { l1Values.isTestContext = _mode == .test }
            return l1Values[K.self]
        }
        set { _l1Values[K.self] = newValue }
    }
}

extension __DependencyValues {

    @inlinable
    public func _scope<T, E: Swift.Error>(
        _ operation: () throws(E) -> T
    ) throws(E) -> T {
        try Witness.Context._withScope(
            mode: _mode,
            { witnessValues, l1Values in
                witnessValues = _witnessValues
                l1Values = _l1Values
                if let _mode { l1Values.isTestContext = _mode == .test }
            },
            operation: operation
        )
    }

    @inlinable
    nonisolated(nonsending)
        public func _scope<T, E: Swift.Error>(
            _ operation: nonisolated(nonsending) () async throws(E) -> T
        ) async throws(E) -> T
    {
        try await Witness.Context._withScope(
            mode: _mode,
            { witnessValues, l1Values in
                witnessValues = _witnessValues
                l1Values = _l1Values
                if let _mode { l1Values.isTestContext = _mode == .test }
            },
            operation: operation
        )
    }
}
