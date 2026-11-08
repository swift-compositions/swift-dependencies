public import Witnesses

@usableFromInline
internal enum _Accessor<Value: Sendable>: @unchecked Sendable {
    case keyPath(KeyPath<__DependencyValues, Value>)
    case closure(@Sendable (__DependencyValues) -> Value)
}
