#if RFC4122
    internal import Dependencies
    internal import Synchronization

    extension __DependencyGenerator.UUID {

        internal final class Sequences: Sendable {

            private struct Entry: Sendable {
                weak let root: __DependencyContext.Root?
                let generator: __DependencyGenerator.UUID
            }

            private let entries = Mutex<[Entry]>([])

            internal func generator(for root: __DependencyContext.Root) -> __DependencyGenerator.UUID {
                entries.withLock { entries in
                    if let entry = entries.first(where: { $0.root === root }) {
                        return entry.generator
                    }
                    entries.removeAll { $0.root == nil }
                    let generator = __DependencyGenerator.UUID.incrementing
                    entries.append(Entry(root: root, generator: generator))
                    return generator
                }
            }
        }
    }
#endif
