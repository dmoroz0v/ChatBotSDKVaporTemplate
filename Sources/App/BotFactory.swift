import Foundation
import TgBotSDK
import Vapor

public final class BotFactory {

    public init() {}

    public func tgBot(_ app: Application) -> TgBotSDK.Bot {
        return TgBotSDK.Bot(
            flowStorage: FlowStorageImpl(db: app.db),
            botAssembly: BotAssemblyImpl(db: app.db),
            token: "",
            apiEndpoint: "https://api.telegram.org/bot"
        )
    }
}
