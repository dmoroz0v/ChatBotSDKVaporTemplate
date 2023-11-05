import Vapor
import ChatBotSDK
import Fluent
import FluentSQLiteDriver

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.databases.use(DatabaseConfigurationFactory.sqlite(.file("db.sqlite")), as: .sqlite)
    app.migrations.add(CreateFlow())
    app.migrations.add(CreateRow())
    try app.autoMigrate().wait()

    let encoder = JSONEncoder()
    encoder.keyEncodingStrategy = .convertToSnakeCase
    ContentConfiguration.global.use(encoder: encoder, for: .json)

    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    ContentConfiguration.global.use(decoder: decoder, for: .json)

    //app.http.server.configuration.hostname = "..."
    //app.http.server.configuration.port = ...
    //
    //try app.http.server.configuration.tlsConfiguration = .forServer(
    //    certificateChain: [
    //        .certificate(.init(
    //            file: "cert.pem",
    //            format: .pem
    //        ))
    //    ],
    //    privateKey: .file("key.pem")
    //)

    // register routes
    try routes(app)
}
