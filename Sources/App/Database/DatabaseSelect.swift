import Foundation
import ChatBotSDK
import Fluent
import Vapor

final class DatabaseSelectOperationFlowAssembly: FlowAssembly {

    let initialHandlerId: String
    let inputHandlers: [String: FlowInputHandler]
    let action: FlowAction
    let context: Any?

    init(app: Application) {
        let databaseSelectAction = DatabaseSelectOperationAction(app: app)

        initialHandlerId = ""
        inputHandlers = [:]
        action = databaseSelectAction
        context = nil
    }

}

final class DatabaseSelectOperationAction: FlowAction {
    let app: Application

    init(app: Application) {
        self.app = app
    }

    func execute(userId: Int64) -> [String] {
        do {
            let rows = try Row.query(on: app.db).filter(\.$userId == userId).all().wait()
            return [rows.map({ $0.value }).joined(separator: "\n")]
        } catch let e {
            return [e.localizedDescription]
        }
    }

}
