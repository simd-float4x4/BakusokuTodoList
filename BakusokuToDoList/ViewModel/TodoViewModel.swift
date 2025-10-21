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
    @Published var mode: SectionTitle = .ALL {
        didSet {
            fetchTodos(current: mode)
        }
    }

    init() {
        realm = try! Realm()
        fetchTodos(current: mode)
    }

    private func fetchTodos(current: SectionTitle) {
        var results = realm.objects(Todo.self)
        
        switch current {
        case .ALL:
            results = results.where({ $0.isDelete == false })
        case .CHECKED:
            results = results.where({ $0.isDelete == false && $0.isComplete == true})
        case .CURRENTLY_DETLETED:
            results = results.where({ $0.isDelete == true})
        case .NORMAL:
            results = results.where({ $0.isDelete == false && $0.isComplete == false})
        default:
            break
        }
    
        notificationToken = results.observe { [weak self] changes in
            guard let self = self else { return }
            switch changes {
            case .initial(let results):
                self.todoList = Array(results)
            case .update(let results, _, _, _):
                self.todoList = Array(results)
            case .error(let error):
                print("Error observing todos: \(error)")
            }
        }
    }
    
    func enabledPressDeleteButton() -> Bool {
        var b = true
        let result = realm.objects(Todo.self).where({ $0.isDelete == true })
        if result.isEmpty { b = !b }
        return b
    }
    
    func deleteAllTodo() {
        Task {
            do {
                let realmInstance = try Realm()
                let todosToDelete = realmInstance.objects(Todo.self).where { $0.isDelete == true }
                try realmInstance.write {
                    realmInstance.delete(todosToDelete)
                }
            } catch {
                print("❌ Error during permanent deletion of todos: \(error)")
            }
        }
        fetchTodos(current: .CURRENTLY_DETLETED)
    }

    deinit {
        notificationToken?.invalidate()
    }
}
