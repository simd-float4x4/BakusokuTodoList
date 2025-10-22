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
    
    func reloadData() {
        todoList = Array(realm.objects(Todo.self))
    }
    
    
    func fetchTodos(current: SectionTitle) {
        var results = realm.objects(Todo.self)
        
        switch current {
        case .ALL:
            results = results.where({ $0.isDelete == false })
        case .CHECKED:
            results = results.where({ $0.isDelete == false && $0.isComplete == true }).sorted(byKeyPath: "completedAt", ascending: false)
        case .CURRENTLY_DETLETED:
            results = results.where({ $0.isDelete == true })
        case .NORMAL:
            results = results.where({ $0.isDelete == false && $0.isComplete == false && $0.isFavorite == false })
        case .STAR:
            results = results.where({ $0.isDelete == false && $0.isFavorite == true })
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
    
    func updateTodoContent(uuid: String, updatedText: String) {
        if let todo = realm.object(ofType: Todo.self, forPrimaryKey: uuid) {
            try! realm.write {
                todo.todo = updatedText
                print(todo.todo, "にupdateされました")
            }
        }
    }
    
    func enabledPressDeleteButton() -> Bool {
        return realm.objects(Todo.self).where({ $0.isDelete == true }).isEmpty
    }
    
    func deleteAllTodo() {
        Task {
            do {
                let todos = realm.objects(Todo.self).where { $0.isDelete == true }
                try realm.write {
                    realm.delete(todos)
                }
                fetchTodos(current: .CURRENTLY_DETLETED)
            } catch {
                print("Error during permanent deletion of todos: \(error)")
            }
        }
    }

    deinit {
        notificationToken?.invalidate()
    }
}
