import Dependencies_Environment_Integration
import Dependencies_Test_Support
import Testing

extension EnvVars {
    @Suite
    struct Test {
        @Suite struct Unit {}
        @Suite struct `Edge Case` {}
        @Suite struct Integration {}
    }
}

extension EnvVars.Test.Unit {
    @Test
    func `dictionary storage and scalar accessors`() throws {
        var envVars = try EnvVars(
            dictionary: [
                "PORT": "8080",
                "CANONICAL_HOST": "example.com",
                "EMERGENCY_MODE": "1",
                "HTTPS_REDIRECT": "true",
                "LOCAL-SSL-SERVER-CRT": "certificate",
                "LOCAL-SSL-SERVER-KEY": "private-key",
                "APPLE-DEVELOPER-MERCHANTID-DOMAIN-ASSOCIATION": "association",
                "TAXIDENTIFICATIONNUMBER": "NL123",
            ],
            requiredKeys: ["PORT"]
        )

        #expect(try envVars.port() == 8080)
        #expect(envVars.canonicalHost == "example.com")
        #expect(envVars.emergencyMode)
        #expect(envVars.httpsRedirect == true)
        #expect(envVars.localSslServerCrt == "certificate")
        #expect(envVars.localSslServerKey == "private-key")
        #expect(envVars.appleDeveloperMerchantIdDomainAssociation == "association")
        #expect(envVars.taxIdentificationNumber == "NL123")

        envVars.setPort(3000)
        envVars.canonicalHost = nil
        envVars.emergencyMode = false
        envVars.httpsRedirect = false
        envVars.localSslServerCrt = nil
        envVars.localSslServerKey = nil
        envVars.appleDeveloperMerchantIdDomainAssociation = nil
        envVars.taxIdentificationNumber = nil

        #expect(envVars["PORT"] == "3000")
        #expect(envVars["CANONICAL_HOST"] == nil)
        #expect(envVars["EMERGENCY_MODE"] == "0")
        #expect(envVars["HTTPS_REDIRECT"] == "false")
        #expect(envVars["LOCAL-SSL-SERVER-CRT"] == nil)
        #expect(envVars["LOCAL-SSL-SERVER-KEY"] == nil)
        #expect(envVars["APPLE-DEVELOPER-MERCHANTID-DOMAIN-ASSOCIATION"] == nil)
        #expect(envVars["TAXIDENTIFICATIONNUMBER"] == nil)
    }

    @Test
    func `package fixture remains available`() {
        #expect(EnvVars.localWebDevelopment["APP_ENV"] == "testing")
        #expect(Set<String>.requiredKeys == ["APP_SECRET", "APP_ENV", "BASE_URL", "PORT"])
    }
}

extension EnvVars.Test.`Edge Case` {
    @Test
    func `missing required key throws`() {
        #expect(throws: EnvVarsError.self) {
            try EnvVars(dictionary: [:], requiredKeys: ["REQUIRED"])
        }
    }

    @Test
    func `invalid port throws`() {
        let envVars = EnvVars(["PORT": "not-an-integer"])
        #expect(throws: EnvVarsError.self) {
            try envVars.port()
        }
    }

    @Test
    func `optional and boolean edge values retain legacy semantics`() {
        var envVars = EnvVars([
            "EMERGENCY_MODE": "true",
            "HTTPS_REDIRECT": "anything-other-than-true",
        ])

        #expect(!envVars.emergencyMode)
        #expect(envVars.httpsRedirect == false)

        envVars["HTTPS_REDIRECT"] = nil
        #expect(envVars.httpsRedirect == nil)
    }
}

extension EnvVars.Test.Integration {
    @Test
    func `process-only live construction and dependency key compile`() throws {
        let live = try EnvVars.live()

        withDependencies {
            $0.envVars = live
        } operation: {
            @Dependency(\.envVars) var envVars
            #expect(envVars.storage == live.storage)
        }
    }
}

extension EnvVars.Test.Unit {
    @Test
    func `URL accessors round trip`() throws {
        var envVars = EnvVars(["BASE_URL": "https://example.com"])
        #expect(URLs.string(try envVars.baseUrl()) == "https://example.com")

        envVars.setBaseUrl(try #require(URLs.url("https://swift.org")))
        #expect(envVars["BASE_URL"] == "https://swift.org")
    }

    @Test
    func `allowed insecure hosts preserves CharacterSet whitespace semantics`() {
        var envVars = EnvVars([
            "ALLOWED_INSECURE_HOSTS": "\u{00A0}localhost\u{00A0}, 127.0.0.1\t"
        ])
        #expect(envVars.allowedInsecureHosts == ["localhost", "127.0.0.1"])

        envVars.allowedInsecureHosts = ["newhost.com", "another.com"]
        #expect(envVars["ALLOWED_INSECURE_HOSTS"] == "newhost.com,another.com")
    }
}

extension EnvVars.Test.`Edge Case` {
    @Test
    func `invalid URL throws`() {
        let envVars = EnvVars(["BASE_URL": "http://[::1"])
        #expect(throws: EnvVarsError.self) {
            try envVars.baseUrl()
        }
    }

    @Test
    func `missing host list remains nil`() {
        #expect(EnvVars().allowedInsecureHosts == nil)
    }

    @Test
    func `no dotenv file reads the process environment only`() throws {
        _ = try EnvVars.live(localEnvFile: nil)
    }

    @Test
    func `empty host list value retains one empty component`() {
        #expect(EnvVars(["ALLOWED_INSECURE_HOSTS": ""]).allowedInsecureHosts == [""])
    }
}

extension EnvVars.Test.Integration {
    @Test
    func `dotenv URL overlay wins over process environment`() throws {
        let file = try URLs.envExample()
        defer { URLs.remove(file) }

        let direct = try EnvVars.live(localEnvFile: file)
        let configured = try EnvVars.live(environmentConfiguration: .localEnvFile(file))

        #expect(direct["APP_SECRET"] == "deadbeefdeadbeefdeadbeefdeadbeef")
        #expect(configured["BASE_URL"] == "http://localhost:8080")
    }

    @Test
    func `project root dependency key accepts Foundation URL`() {
        let root = URLs.file("/tmp/project")
        withDependencies {
            $0.projectRoot = root
        } operation: {
            @Dependency(\.projectRoot) var projectRoot
            #expect(projectRoot == root)
        }
    }
}
