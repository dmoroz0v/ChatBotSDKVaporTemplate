import Foundation
import ChatBotSDK
import Fluent

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

        CommandHandler(
            command: Command(value: "/insert"),
            description: "Insert value",
            flowAssembly: DatabaseInsertOperationFlowAssembly(db: db)
        ),

        CommandHandler(
            command: Command(value: "/select"),
            description: "Select values",
            flowAssembly: DatabaseSelectOperationFlowAssembly(db: db)
        ),

    ]

    private let db: Database

    public init(db: Database) {
        self.db = db
    }

}
