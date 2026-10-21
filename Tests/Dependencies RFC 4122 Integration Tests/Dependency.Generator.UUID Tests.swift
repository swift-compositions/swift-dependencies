#if RFC4122
    import Dependencies_RFC_4122_Integration
    import Dependencies_Test_Support
    import Testing

    @Suite(.dependencies)
    struct `Dependency.Generator.UUID Tests` {

        static func counter(of uuid: RFC_4122.UUID) -> UInt64 {
            uuid.byteArray[8...].reduce(0) { $0 << 8 | UInt64($1) }
        }

        @Test
        func `An incrementing generator starts at zero and counts up`() {
            withDependencies {
                $0.uuid = .incrementing
            } operation: {
                @Dependency(\.uuid) var uuid
                let values = (0..<3).map { _ in uuid() }
                #expect(values.map(Self.counter(of:)) == [0, 1, 2])
                #expect(values.allSatisfy { value in value.byteArray[..<8].allSatisfy { $0 == 0 } })
            }
        }

        @Test
        func `Each incrementing override starts its own sequence`() {
            for _ in 0..<2 {
                withDependencies {
                    $0.uuid = .incrementing
                } operation: {
                    @Dependency(\.uuid) var uuid
                    #expect(Self.counter(of: uuid()) == 0)
                    #expect(Self.counter(of: uuid()) == 1)
                }
            }
        }

        @Test
        func `The test value increases on every call`() {
            @Dependency(\.uuid) var uuid
            let first = Self.counter(of: uuid())
            let second = Self.counter(of: uuid())
            #expect(second > first)
        }

        @Test
        func `A constant generator repeats its value`() {
            let fixed = RFC_4122.UUID.dns
            withDependencies {
                $0.uuid = .constant(fixed)
            } operation: {
                @Dependency(\.uuid) var uuid
                #expect(uuid() == fixed)
                #expect(uuid() == fixed)
            }
        }

        @Test
        func `Child tasks share one incrementing sequence`() async {
            let values = await withDependencies {
                $0.uuid = .incrementing
            } operation: {
                await withTaskGroup(of: UInt64.self) { group in
                    for _ in 0..<16 {
                        group.addTask {
                            Self.counter(of: Dependency<Never>.Context.current.uuid())
                        }
                    }
                    var values: [UInt64] = []
                    for await value in group {
                        values.append(value)
                    }
                    return values.sorted()
                }
            }
            #expect(values == Array(0..<16))
        }

        @Test
        func `The live value produces distinct version 4 identifiers`() {
            withDependencies(
                mode: .live,
                operation: {
                    @Dependency(\.uuid) var uuid
                    let first = uuid()
                    let second = uuid()
                    #expect(first != second)
                    #expect(first.byteArray[6] >> 4 == 4)
                    #expect(first.byteArray[8] & 0xC0 == 0x80)
                }
            )
        }
    }
#endif
