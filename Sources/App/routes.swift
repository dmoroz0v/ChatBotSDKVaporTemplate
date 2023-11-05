import Vapor
import TgBotSDK

func routes(_ app: Application) throws {

    app.get() { req in
        return "It's work!."
    }

    app.post("webhook") { req -> String in
        let b = BotFactory().tgBot(app)
        let update = try req.content.decode(Update.self)
        b.handleUpdate(update: update)
        return "Ok"
    }
}
