import Foundation
import App
import TgBotSDK
import ChatBotSDK

FileManager.ChatBotSDK.instance = FileManager.ChatBotSDK(documentsUrl: URL(fileURLWithPath: "./.documents"))
if !FileManager.default.fileExists(
    atPath: FileManager.ChatBotSDK.instance.documentsUrl.path
) {
    try? FileManager.default.createDirectory(
        at: FileManager.ChatBotSDK.instance.documentsUrl,
        withIntermediateDirectories: true,
        attributes: nil)
}

struct Config: Decodable {
    let telegram_bot_token: String
}


let b = TgBotSDK.Bot(
    flowStorage: try! FlowStorageImpl(),
    botAssembly: BotAssemblyImpl(),
    token: "",
    apiEndpoint: "https://api.telegram.org/bot")

DispatchQueue.global().async {
    while true {
        b.handleUpdates()
    }
}

dispatchMain()
