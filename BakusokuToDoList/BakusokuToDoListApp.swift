//
//  BakusokuToDoListApp.swift
//  BakusokuToDoList
//
//  Created by Shumpei Horiuchi on 2025/10/19.
//

import SwiftUI
import RealmSwift
import Realm

@main
struct BakusokuToDoListApp: SwiftUI.App {
    init() {
        setupRealmMigration()
    }

    var body: some Scene {
        WindowGroup {
            TodoListView()
        }
    }
    
    private func setupRealmMigration() {
        let config = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 1 {
                    migration.enumerateObjects(ofType: Todo.className()) { _, newObject in
                        newObject!["isDelete"] = false
                    }
                }
            }
        )
        Realm.Configuration.defaultConfiguration = config
    }
}

