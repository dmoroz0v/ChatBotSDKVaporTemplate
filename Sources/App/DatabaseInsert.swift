import Foundation
import ChatBotSDK
import Fluent

final class DatabaseInsertOperationFlowAssembly: FlowAssembly {

    let initialHandlerId: String
    let inputHandlers: [String: FlowInputHandler]
    let action: FlowAction
    let context: Storable?

    init(db: Database) {
        let databaseInsertContext = DatabaseInsertContext()

        let handler = DatabaseInsertFlowInputHandler()
        handler.context = databaseInsertContext

        let databaseInsertAction = DatabaseInsertOperationAction(db: db)
        databaseInsertAction.context = databaseInsertContext

        initialHandlerId = "databaseInsert"
        inputHandlers = ["databaseInsert" : handler]
        action = databaseInsertAction
        context = databaseInsertContext
    }

}

final class DatabaseInsertContext: Storable {

    var text: String?

    func store() -> StorableContainer {
        let container =  StorableContainer()
        container.setString(value: text, key: "text")
        return container
    }

    func restore(container: StorableContainer) {
        text = container.stringValue(key: "text")
    }

}

final class DatabaseInsertOperationAction: FlowAction {

    let db: Database

    var context: DatabaseInsertContext?

    init(db: Database) {
        self.db = db
    }

    func execute(userId: Int64) -> [String] {
        if let text = context?.text {
            do {
                let r = Row(userId: userId, value: text)
                try r.save(on: db).wait()
                return ["Succeeded"]
            } catch let e {
                return [e.localizedDescription]
            }
        } else {
            return ["error"]
        }
    }

}

final class DatabaseInsertFlowInputHandler: FlowInputHandler {

    var context: DatabaseInsertContext?

    func start(userId: Int64) -> FlowInputHandlerMarkup {
        return FlowInputHandlerMarkup(texts: ["Type text"])
    }

    func handle(userId: Int64, text: String) -> FlowInputHandlerResult {
        context?.text = text
        return .end
    }

    func store() -> StorableContainer {
        return StorableContainer()
    }

    func restore(container: StorableContainer) {
    }

}
