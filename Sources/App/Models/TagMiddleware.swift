import Fluent

struct TagMiddleware: ModelMiddleware {
    func create(model: Tag, on db: Database, next: AnyModelResponder) -> EventLoopFuture<Void> {
        print("CREATING")
        return next.create(model, on: db).map { print("CREATED") }
    }
    
    func delete(model: Tag, force: Bool, on db: Database, next: AnyModelResponder) -> EventLoopFuture<Void> {
        print("DELETING")
        return next.delete(model, force: force, on: db).map { print("DELETED") }
    }
}
