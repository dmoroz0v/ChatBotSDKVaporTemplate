{{#fluent}}import NIOSSL
import Fluent
import Fluent{{fluent.db.module}}Driver
{{/fluent}}{{#leaf}}import Leaf
{{/leaf}}import Vapor
import ChatBotSDK
import TgBotSDK
import AsyncHTTPClient
import NIOFileSystem

// configures your application
public func configure(_ app: Application, bot: TgBotSDK.Bot) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory)){{#fluent}}

    {{#fluent.db.is_postgres}}app.databases.use(DatabaseConfigurationFactory.postgres(configuration: .init(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? SQLPostgresConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
        password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
        database: Environment.get("DATABASE_NAME") ?? "vapor_database",
        tls: .prefer(try .init(configuration: .clientDefault)))
    ), as: .psql){{/fluent.db.is_postgres}}{{#fluent.db.is_mysql}}    app.databases.use(DatabaseConfigurationFactory.mysql(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? MySQLConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
        password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
        database: Environment.get("DATABASE_NAME") ?? "vapor_database"
    ), as: .mysql){{/fluent.db.is_mysql}}{{#fluent.db.is_mongo}}try app.databases.use(DatabaseConfigurationFactory.mongo(
        connectionString: Environment.get("DATABASE_URL") ?? "mongodb://localhost:27017/vapor_database"
    ), as: .mongo){{/fluent.db.is_mongo}}{{#fluent.db.is_sqlite}}app.databases.use(DatabaseConfigurationFactory.sqlite(.file("db.sqlite")), as: .sqlite){{/fluent.db.is_sqlite}}

    app.migrations.add(CreateRow())
    try await app.autoMigrate(){{/fluent}}{{#leaf}}

    app.views.use(.leaf)

    {{/leaf}}

    let encoder = JSONEncoder()
    encoder.keyEncodingStrategy = .convertToSnakeCase
    ContentConfiguration.global.use(encoder: encoder, for: .json)

    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    ContentConfiguration.global.use(decoder: decoder, for: .json)

    let botToken = Environment.get("BOT_TOKEN") ?? ""

    if Environment.get("BOT_MODE") == "WEBHOOK" {
        app.http.server.configuration.hostname = Environment.get("BOT_DOMAIN") ?? ""
        app.http.server.configuration.port = 8443

        try app.http.server.configuration.tlsConfiguration = .makeServerConfiguration(
            certificateChain: [
                .certificate(.init(
                    file: "Cert/cert.pem",
                    format: .pem
                ))
            ],
            privateKey: .file("Cert/key.pem")
        )

        
        let fileHandle = try await FileSystem.shared.openFile(forReadingAt: .init("Cert/cert.pem"))
        var certBuffer = try await fileHandle.readToEnd(maximumSizeAllowed: .unlimited)
        let certData = certBuffer.readData(length: certBuffer.readableBytes) ?? Data()
        try await fileHandle.close()
        let botDomain = Environment.get("BOT_DOMAIN") ?? ""

        let multipartFormDataRequest = MultipartFormDataRequest()
        multipartFormDataRequest.addTextField(named: "url", value: "https://\(botDomain):8443/webhook")
        if let botIpAddress = Environment.get("BOT_IP_ADDRESS") {
            multipartFormDataRequest.addTextField(named: "ip_address", value: botIpAddress)
        }
        multipartFormDataRequest.addDataField(
            named: "certificate",
            filename: "cert.pem",
            data: certData,
            mimeType: "application/octet-stream"
        )
        let data = multipartFormDataRequest.asData()
        var request = HTTPClientRequest(url: "https://api.telegram.org/bot\(botToken)/setWebhook")
        request.method = .POST
        request.body = .bytes(data)
        request.headers.contentType = .init(type: "multipart", subType: "form-data", parameters: [
            "boundary": multipartFormDataRequest.boundary
        ])
        _ = try await app.http.client.shared.execute(request, timeout: .seconds(30))
    } else {
        var request = HTTPClientRequest(url: "https://api.telegram.org/bot\(botToken)/deleteWebhook")
        request.method = .POST
        _ = try await app.http.client.shared.execute(request, timeout: .seconds(30))
    }

    // register routes
    try routes(app, bot: bot)
}

struct MultipartFormDataRequest {
    let boundary: String = UUID().uuidString
    private var httpBody = NSMutableData()

    func addTextField(named name: String, value: String) {
        httpBody.append(textFormField(named: name, value: value))
    }

    private func textFormField(named name: String, value: String) -> String {
        var fieldString = "--\(boundary)\r\n"
        fieldString += "Content-Disposition: form-data; name=\"\(name)\"\r\n"
        fieldString += "\r\n"
        fieldString += "\(value)\r\n"

        return fieldString
    }

    func addDataField(named name: String, filename: String, data: Data, mimeType: String) {
        httpBody.append(dataFormField(named: name, filename: filename, data: data, mimeType: mimeType))
    }

    private func dataFormField(named name: String,
                               filename: String,
                               data: Data,
                               mimeType: String) -> Data {
        let fieldData = NSMutableData()

        fieldData.append("--\(boundary)\r\n")
        fieldData.append("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(filename)\"\r\n")
        fieldData.append("Content-Type: \(mimeType)\r\n")
        fieldData.append("\r\n")
        fieldData.append(data)
        fieldData.append("\r\n")

        return fieldData as Data
    }

    func asData() -> Data {
        httpBody.append("--\(boundary)--")
        return httpBody as Data
    }
}

extension NSMutableData {
  func append(_ string: String) {
    if let data = string.data(using: .utf8) {
      self.append(data)
    }
  }
}
