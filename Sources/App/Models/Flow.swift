import Fluent
import Vapor

final class Flow: Model, Content {
    static let schema = "flows"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "userId")
    var userId: Int64

    @Field(key: "value")
    var value: String

    init() { }

    init(id: UUID? = nil, userId: Int64, value: String) {
        self.id = id
        self.userId = userId
        self.value = value
    }
}
