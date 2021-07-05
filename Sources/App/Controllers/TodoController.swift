import Fluent
import Vapor

struct TodoController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let todos = routes.grouped("todos")
        todos.get(use: index)
        todos.post(use: create)
        todos.group(":todoID") { todo in
            todo.delete(use: delete)
            todo.group("tags", ":tagID") { tags in
                tags.post(use: attachTag)
                tags.delete(use: detachTag)
            }
        }
    }

    func index(req: Request) throws -> EventLoopFuture<[Todo]> {
        return Todo.query(on: req.db)
            .with(\.$tags)
            .all()
    }

    func create(req: Request) throws -> EventLoopFuture<Todo> {
        let todo = try req.content.decode(Todo.self)
        return todo.save(on: req.db).map { todo }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Todo.find(req.parameters.get("todoID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
    
    func attachTag(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let todo = Todo.find(req.parameters.get("todoID"), on: req.db)
            .unwrap(or: Abort(.notFound))
        let tag = Tag.find(req.parameters.get("tagID"), on: req.db)
            .unwrap(or: Abort(.notFound))
        
        return todo.and(tag).flatMap { todo, tag in
            todo.$tags.attach(tag, on: req.db).transform(to: .ok)
        }
    }
    
    func detachTag(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let todo = Todo.find(req.parameters.get("todoID"), on: req.db)
            .unwrap(or: Abort(.notFound))
        let tag = Tag.find(req.parameters.get("tagID"), on: req.db)
            .unwrap(or: Abort(.notFound))
        
        return todo.and(tag).flatMap { todo, tag in
            todo.$tags.detach(tag, on: req.db).transform(to: .ok)
        }
    }
}
