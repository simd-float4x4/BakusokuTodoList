//
//  Todo.swift
//  BakusokuToDoList
//
//  Created by Shumpei Horiuchi on 2025/10/19.
//

import Foundation
import RealmSwift

class Todo: Object {
    @Persisted(primaryKey: true) var uuid: String
    @Persisted var todo: String
    @Persisted var createdAt: Date
    @Persisted var isComplete: Bool
    @Persisted var completedAt: Date?
    @Persisted var isDelete: Bool

    convenience init(todo: String) {
        self.init()
        self.uuid = UUID().uuidString
        self.todo = todo
        self.isComplete = false
        self.createdAt = Date()
        self.isDelete = false
    }
}
