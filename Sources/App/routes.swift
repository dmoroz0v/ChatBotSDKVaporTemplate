{{#fluent}}import Fluent
{{/fluent}}import Vapor
import ChatBotSDK
import TgBotSDK

func routes(_ app: Application) throws {

    app.get("hello") { req -> String in
        return "Hello, world!"
    }{{#fluent}}

    app.post("webhook") { req -> String in
        let b = TgBotSDK.Bot(
            flowStorage: try! FlowStorageImpl(),
            botAssembly: BotAssemblyImpl(),
            token: "",
            apiEndpoint: "https://api.telegram.org/bot")

        let update = try req.content.decode(Update.self)

        b.handleUpdate(update: update)

        return "Ok"
    }

    try app.register(collection: TodoController()){{/fluent}}
}
