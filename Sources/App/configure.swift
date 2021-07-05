import Fluent
import FluentPostgresDriver
import Vapor

public func configure(_ app: Application) throws {
    try app.databases.use(.postgres(url: "postgres://jaw@localhost:5432/todos"), as: .psql)

    app.migrations.add(CreateTodo())
    app.migrations.add(CreateTag())
    app.migrations.add(CreateTodoTag())
    
    app.databases.middleware.use(TodoMiddleware(), on: .psql)
    app.databases.middleware.use(TagMiddleware(), on: .psql)
    app.databases.middleware.use(TodoTagMiddleware(), on: .psql)

    try app.register(collection: TodoController())
    try app.register(collection: TagController())
}
