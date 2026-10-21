import Dependencies
import Dependencies_Test_Support
import Testing

@Suite(.dependencies)
struct `Task Propagation Tests` {

    @Test
    func `An unstructured task inherits the scope it was created in`() async {
        let value = await withDependencies {
            $0.greeting = "scoped"
        } operation: {
            await Task {
                Dependency<Never>.Context.current.greeting
            }.value
        }
        #expect(value == "scoped")
    }

    @Test
    func `An unstructured task keeps its scope after the scope has ended`() async {
        let task = await withDependencies {
            $0.greeting = "captured at creation"
        } operation: {
            Task {
                await Task.yield()
                return Dependency<Never>.Context.current.greeting
            }
        }
        let value = await withDependencies {
            $0.greeting = "awaited elsewhere"
        } operation: {
            await task.value
        }
        #expect(value == "captured at creation")
    }

    @Test
    func `An unstructured task inherits the context`() async {
        let context = await withDependencies(
            mode: .preview,
            operation: {
                await Task {
                    Dependency<Never>.Context.current.context
                }.value
            }
        )
        #expect(context == .preview)
    }

    @Test
    func `A detached task does not inherit the scope`() async {
        let observed = await withDependencies {
            $0.greeting = "scoped"
        } operation: {
            await Task.detached {
                (
                    Dependency<Never>.Context.current.greeting,
                    Dependency<Never>.Context.current.context
                )
            }.value
        }
        #expect(observed.0 == "live greeting")
        #expect(observed.1 == .live)
    }

    @Test
    func `A detached task can adopt a scope through an escaped continuation`() async {
        let value = await withDependencies {
            $0.greeting = "escaped"
        } operation: {
            await withEscapedDependencies { continuation in
                await Task.detached {
                    continuation.yield {
                        Dependency<Never>.Context.current.greeting
                    }
                }.value
            }
        }
        #expect(value == "escaped")
    }

    @Test
    func `Task group children inherit the scope`() async {
        let values = await withDependencies {
            $0.greeting = "grouped"
        } operation: {
            await withTaskGroup(of: String.self) { group in
                for _ in 0..<8 {
                    group.addTask {
                        Dependency<Never>.Context.current.greeting
                    }
                }
                var values: [String] = []
                for await value in group {
                    values.append(value)
                }
                return values
            }
        }
        #expect(values == Array(repeating: "grouped", count: 8))
    }

    @Test
    func `Task group children override independently`() async {
        let values = await withTaskGroup(of: Int.self) { group in
            for index in 0..<8 {
                group.addTask {
                    await withDependencies {
                        $0.number = index
                    } operation: {
                        await Task.yield()
                        return Dependency<Never>.Context.current.number
                    }
                }
            }
            var values: [Int] = []
            for await value in group {
                values.append(value)
            }
            return values.sorted()
        }
        #expect(values == Array(0..<8))
    }

    @Test
    func `Async let children inherit the scope`() async {
        let (first, second) = await withDependencies {
            $0.greeting = "bound"
            $0.number = 3
        } operation: {
            async let first = Dependency<Never>.Context.current.greeting
            async let second = Dependency<Never>.Context.current.number
            return await (first, second)
        }
        #expect(first == "bound")
        #expect(second == 3)
    }

    @Test
    func `Async let children see a scope entered inside them`() async {
        await withDependencies {
            $0.number = 1
        } operation: {
            async let inner: Int = await withDependencies {
                $0.number += 1
            } operation: {
                Dependency<Never>.Context.current.number
            }
            async let outer = Dependency<Never>.Context.current.number
            let values = await (inner, outer)
            #expect(values.0 == 2)
            #expect(values.1 == 1)
        }
    }

    @Test
    func `A stream element is produced in the consumer's scope unless escaped`() async {
        let (plain, escaped) = await withDependencies {
            $0.greeting = "producer"
        } operation: {
            let plain = AsyncStream<String>(unfolding: {
                Dependency<Never>.Context.current.greeting
            })
            let escaped = withEscapedDependencies { continuation in
                AsyncStream<String>(unfolding: {
                    continuation.yield {
                        Dependency<Never>.Context.current.greeting
                    }
                })
            }
            return (plain, escaped)
        }
        await withDependencies {
            $0.greeting = "consumer"
        } operation: {
            var plainIterator = plain.makeAsyncIterator()
            var escapedIterator = escaped.makeAsyncIterator()
            #expect(await plainIterator.next() == "consumer")
            #expect(await escapedIterator.next() == "producer")
        }
    }
}
