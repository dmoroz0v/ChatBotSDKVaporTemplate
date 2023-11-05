import Foundation
import App
import TgBotSDK

import App
import Vapor

var env = try Environment.detect()
try LoggingSystem.bootstrap(from: &env)
let app = Application(env)
try configure(app)

let b = BotFactory().tgBot(app)

DispatchQueue.global().async {
    while true {
        b.handleUpdates()
    }
}

dispatchMain()
