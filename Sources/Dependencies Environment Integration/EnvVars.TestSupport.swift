extension EnvVars {
    package static var localWebDevelopment: EnvVars {
        EnvVars([
            "APP_ENV": "testing",
            "APP_SECRET": "test_secret",
            "BASE_URL": "http://localhost:8080",
            "PORT": "8080",
            "GITHUB_CLIENT_ID": "test_github_id",
            "GITHUB_CLIENT_SECRET": "test_github_secret",
            "DATABASE_URL": "postgres://test:test@localhost:5432/test_db",
        ])
    }
}

extension Set<String> {
    static let localWebDevelopmentEnvVarsRequiredKeys: Set<String> = [
        "APP_SECRET",
        "APP_ENV",
        "BASE_URL",
        "PORT",
    ]

    public static let requiredKeys: Set<String> = [
        "APP_SECRET",
        "APP_ENV",
        "BASE_URL",
        "PORT",
    ]
}
