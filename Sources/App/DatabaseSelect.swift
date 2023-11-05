import Foundation
import ChatBotSDK
import Fluent

final class DatabaseSelectOperationFlowAssembly: FlowAssembly {

    let initialHandlerId: String
    let inputHandlers: [String: FlowInputHandler]
    let action: FlowAction
    let context: Storable?

    init(db: Database) {
        let databaseSelectAction = DatabaseSelectOperationAction(db: db)

        initialHandlerId = ""
        inputHandlers = [:]
        action = databaseSelectAction
        context = nil
    }

}

final class DatabaseSelectOperationAction: FlowAction {
    let db: Database

    init(db: Database) {
        self.db = db
    }

    func execute(userId: Int64) -> [String] {
        do {
            let rows = try Row.query(on: db).filter(\.$userId == userId).all().wait()
            return [rows.map({ $0.value }).joined(separator: "\n")]
        } catch let e {
            return [e.localizedDescription]
        }
    }

}
