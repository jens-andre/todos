import Fluent

struct CreateTag: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("tags")
            .id()
            .field("name", .string, .required)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("tags").delete()
    }
}
