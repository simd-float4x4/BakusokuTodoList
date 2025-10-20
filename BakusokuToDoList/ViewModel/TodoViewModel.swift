//
//  ViewModel.swift
//  BakusokuToDoList
//
//  Created by Shumpei Horiuchi on 2025/10/19.
//

import Foundation
import RealmSwift
import Combine
import Realm

class TodoViewModel: ObservableObject {
    private var notificationToken: NotificationToken?
    private var realm: Realm

    @Published var todoList: [Todo] = []

    init() {
        realm = try! Realm()
        fetchTodos()
    }

    private func fetchTodos() {
        let results = realm.objects(Todo.self).where { $0.isDelete == false }
        todoList = Array(results)

        notificationToken = results.observe { [weak self] changes in
            guard let self = self else { return }
            switch changes {
            case .initial(let results):
                self.todoList = Array(results)
            case .update(let results, _, _, _):
                self.todoList = Array(results)
                self.todoList = self.todoList.sorted(by: {$0.isComplete == false && $1.isComplete == true})
            case .error(let error):
                print("Error observing todos: \(error)")
            }
        }
    }

    deinit {
        notificationToken?.invalidate()
    }
}
