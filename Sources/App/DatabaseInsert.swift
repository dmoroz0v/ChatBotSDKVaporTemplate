import Foundation
import ChatBotSDK

final class DatabaseInsertOperationFlowAssembly: FlowAssembly {

    let initialHandlerId: String
    let inputHandlers: [String: FlowInputHandler]
    let action: FlowAction
    let context: Storable?

    init() {
        let databaseInsertContext = DatabaseInsertContext()

        let handler = DatabaseInsertFlowInputHandler()
        handler.context = databaseInsertContext

        let databaseInsertAction = DatabaseInsertOperationAction()
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

    var context: DatabaseInsertContext?

    func execute(userId: Int64) -> [String] {
        if let text = context?.text {
            do {
                let database = try Database()
                try database.insert(value: text, userId: userId)
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
