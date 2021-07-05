import Fluent
import Vapor

final class TodoTag: Model {
    static let schema = "book+author"
    
    @ID var id: UUID?
    
    @Parent(key: "todo_id")
    var todo: Todo
    
    @Parent(key: "tag_id")
    var tag: Tag
    
    init() {}
    
    init(id: UUID? = nil, todoID: UUID, tagID: UUID) {
        self.id = id
        self.$todo.id = todoID
        self.$tag.id = tagID
    }
}
