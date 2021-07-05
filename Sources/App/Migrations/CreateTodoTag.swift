import Fluent

struct CreateTodoTag: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(TodoTag.schema)
            .id()
            .field(
                "todo_id",
                .uuid,
                .required,
                .references(Todo.schema, .id)
            )
            .field(
                "tag_id",
                .uuid,
                .required,
                .references(Tag.schema, .id)
            )
            .unique(on: "todo_id", "tag_id")
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(TodoTag.schema).delete()
    }
}
