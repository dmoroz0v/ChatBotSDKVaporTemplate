import Fluent

struct CreateFlow: AsyncMigration {
    func prepare(on database: Fluent.Database) async throws {
        do {
            try await database.schema("flows")
                .id()
                .field("userId", .int64, .required)
                .field("value", .string, .required)
                .create()
        } catch {
            print(error)
            throw error
        }
    }

    func revert(on database: Fluent.Database) async throws {
        try await database.schema("flows").delete()
    }
}
