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
            }
        )
        Realm.Configuration.defaultConfiguration = config
    }
}

