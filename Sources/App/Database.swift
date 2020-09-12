import Foundation
import ChatBotSDK
import SQLite

public final class Database {
    private let db: Connection

    let data = Table("data")
    let id = Expression<Int64>("id")
    let userId = Expression<Int64>("user_id")
    let value = Expression<String>("value")

    public init() throws {
        let url = FileManager.ChatBotSDK.instance.documentsUrl.appendingPathComponent("db.sqlite3")
        let fileExists = FileManager.default.fileExists(atPath: url.path)
        db = try Connection(url.path)

        if !fileExists {
            _ = try? db.run(data.create { t in
                t.column(id, primaryKey: true)
                t.column(userId)
                t.column(value)
            })
        }
    }

    public func insert(value: String, userId: Int64) throws {
        let insert = data.insert(self.value <- value, self.userId <- userId)
        _ = try db.run(insert)
    }

    public func fetch(userId: Int64) throws -> [String] {
        let filter = data.filter(self.userId == userId)
        let result = try db.prepare(filter)
        return Array(result).map {
            return $0[self.value]
        }
    }
}
