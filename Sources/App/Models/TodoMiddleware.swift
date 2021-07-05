import Fluent

struct TodoMiddleware: ModelMiddleware {
    func create(model: Todo, on db: Database, next: AnyModelResponder) -> EventLoopFuture<Void> {
        print("CREATING")
        return next.create(model, on: db).map { print("CREATED") }
    }
    
    func delete(model: Todo, force: Bool, on db: Database, next: AnyModelResponder) -> EventLoopFuture<Void> {
        print("DELETING")
        return next.delete(model, force: force, on: db).map { print("DELETED") }
    }
}
