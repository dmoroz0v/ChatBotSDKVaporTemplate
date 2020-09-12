import Foundation
import ChatBotSDK

final class DatabaseSelectOperationFlowAssembly: FlowAssembly {

    let initialHandlerId: String
    let inputHandlers: [String: FlowInputHandler]
    let action: FlowAction
    let context: Storable?

    init() {
        let databaseSelectAction = DatabaseSelectOperationAction()

        initialHandlerId = ""
        inputHandlers = [:]
        action = databaseSelectAction
        context = nil
    }

}

final class DatabaseSelectOperationAction: FlowAction {

    func execute(userId: Int64) -> [String] {
        do {
            let database = try Database()
            return [try database.fetch(userId: userId).joined(separator: "\n")]
        } catch let e {
            return [e.localizedDescription]
        }
    }

}
