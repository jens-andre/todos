import Fluent
import Vapor

struct TagController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let tags = routes.grouped("tags")
        tags.get(use: index)
        tags.post(use: create)
        tags.group(":tagID") { todo in
            todo.delete(use: delete)
        }
    }

    func index(req: Request) throws -> EventLoopFuture<[Tag]> {
        return Tag.query(on: req.db).all()
    }

    func create(req: Request) throws -> EventLoopFuture<Tag> {
        let tag = try req.content.decode(Tag.self)
        return tag.save(on: req.db).map { tag }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Tag.find(req.parameters.get("tagID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
