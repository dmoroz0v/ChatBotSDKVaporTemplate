{{#fluent}}import Fluent
{{/fluent}}import Vapor
import TgBotSDK

func routes(_ app: Application, bot: TgBotSDK.Bot) throws {
    {{#leaf}}app.get { req async throws in
        try await req.view.render("index", ["title": "Hello Vapor!"])
    }{{/leaf}}{{^leaf}}app.get { req async in
        "It works!"
    }{{/leaf}}

    app.get("hello") { req async -> String in
        "Hello, world!"
    }

    app.post("webhook") { req -> String in
        let update = try req.content.decode(Update.self)
        await bot.handleUpdate(update: update)
        return "Ok"
    }
}
