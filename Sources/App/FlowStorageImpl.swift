import ChatBotSDK
import Foundation
import Fluent

public final class FlowStorageImpl: FlowStorage {

    private let db: Fluent.Database

    public init(db: Fluent.Database) {
        self.db = db
    }

    public func save(value: String?, userId: Int64) {
        if let value = value {
            let f = Flow(userId: userId, value: value)
            do {
                try f.save(on: db).wait()
            } catch {
                print(error)
            }
        } else {
            do {
                let f = try Flow.query(on: db).filter(\.$userId == userId).first().wait()
                try f?.delete(on: db).wait()
            } catch {
                print(error)
            }
        }
    }

    public func fetch(userId: Int64) -> String? {
        let future = Flow.query(on: db).filter(\.$userId == userId).first()
        do {
            let f = try future.wait()
            return f?.value
        } catch {
            print(error)
        }
        return nil
    }

    public func hasRecord(userId: Int64) -> Bool {
        let future = Flow.query(on: db).filter(\.$userId == userId).first()
        do {
            let f = try future.wait()
            return f != nil
        } catch {
            print(error)
        }
        return false
    }

}
