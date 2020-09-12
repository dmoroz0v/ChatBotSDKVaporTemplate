import Foundation
import ChatBotSDK

final class RevertOperationFlowAssembly: FlowAssembly {

    let initialHandlerId: String
    let inputHandlers: [String: FlowInputHandler]
    let action: FlowAction
    let context: Storable?

    init() {
        let revertContext = RevertContext()

        let handler = RevertFlowInputHandler()
        handler.context = revertContext

        let revertAction = RevertOperationAction()
        revertAction.context = revertContext

        initialHandlerId = "revert"
        inputHandlers = ["revert" : handler]
        action = revertAction
        context = revertContext
    }

}

final class RevertContext: Storable {

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

final class RevertOperationAction: FlowAction {

    var context: RevertContext?

    func execute(userId: Int64) -> [String] {
        if let text = context?.text {
            return [String(text.reversed())]
        } else {
            return ["error"]
        }
    }

}

final class RevertFlowInputHandler: FlowInputHandler {

    var context: RevertContext?

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
