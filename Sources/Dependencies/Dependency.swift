public import Witnesses

@propertyWrapper
public struct Dependency<Value: Sendable>: Sendable {
    @usableFromInline
    internal let accessor: _Accessor<Value>

    /// The values in scope where this dependency was created. A read lays the values in scope there over them, so
    /// an object built inside `withDependencies` keeps its overrides when it is used after the scope has ended.
    @usableFromInline
    internal let initial: __DependencyValues

    @usableFromInline
    internal let fileID: StaticString

    @usableFromInline
    internal let line: UInt

    @inlinable
    public init(
        _ keyPath: KeyPath<__DependencyValues, Value>,
        fileID: StaticString = #fileID,
        line: UInt = #line
    ) {
        self.accessor = .keyPath(keyPath)
        self.initial = __DependencyContext.current
        self.fileID = fileID
        self.line = line
    }

    @inlinable
    public init<Key: Dependency.Key>(
        _ key: Key.Type,
        fileID: StaticString = #fileID,
        line: UInt = #line
    ) where Key.Value == Value {
        self.accessor = .closure { $0[Key.self] }
        self.initial = __DependencyContext.current
        self.fileID = fileID
        self.line = line
    }
}


extension Dependency {
    public typealias Values = __DependencyValues

    public typealias Context = __DependencyContext
}

extension Dependency {
    @inlinable
    public var wrappedValue: Value {
        accessor.getValue(from: initial.merging(__DependencyContext.current))
    }}

extension _Accessor {
    @usableFromInline
    func getValue(from values: __DependencyValues) -> Value {
        switch self {
        case .keyPath(let keyPath):
            return values[keyPath: keyPath]

        case .closure(let getter):
            return getter(values)
        }
    }}

extension Dependency {

    public typealias Error = Witness.Unimplemented.Error
}

extension Dependency {

    public typealias Key = Witness.Key
}
