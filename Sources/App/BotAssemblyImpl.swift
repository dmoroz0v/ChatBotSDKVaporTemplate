import Foundation
import ChatBotSDK
{{#fluent}}import Fluent{{/fluent}}
import Vapor

public final class BotAssemblyImpl: BotAssembly {

    public private(set) lazy var commandsHandlers: [CommandHandler] = [

        CommandHandler(
            command: Command(value: "/cancel"),
            description: "Cancel current operation",
            flowAssembly: CancelOperationFlowAssembly()
        ),

        CommandHandler(
            command: Command(value: "/revert"),
            description: "Revert string",
            flowAssembly: RevertOperationFlowAssembly()
        ),

        CommandHandler(
            command: Command(value: "/pick"),
            description: "Pick item",
            flowAssembly: PickerOperationFlowAssembly()
        ),

        {{#fluent}}
        CommandHandler(
            command: Command(value: "/insert"),
            description: "Insert value",
            flowAssembly: DatabaseInsertOperationFlowAssembly(app: app)
        ),

        CommandHandler(
            command: Command(value: "/select"),
            description: "Select values",
            flowAssembly: DatabaseSelectOperationFlowAssembly(app: app)
        ),
        {{/fluent}}

    ]

    private let app: Application

    public init(app: Application) {
        self.app = app
    }

}
