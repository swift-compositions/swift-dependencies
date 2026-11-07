public import Witnesses

@usableFromInline
internal enum _Accessor<Value: Sendable>: @unchecked Sendable {
    case keyPath(KeyPath<__DependencyValues, Value>)
    case closure(@Sendable (__DependencyValues) -> Value)

    @usableFromInline
    func getValue(from values: __DependencyValues) -> Value {
        switch self {
        case .keyPath(let keyPath):
            return values[keyPath: keyPath]

        case .closure(let getter):
            return getter(values)
        }
    }
}
