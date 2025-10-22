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

enum UpdateValue {
    case title
    case isDelete
    case restore
    case isFavorite
    case isComplete
    case deleteAll
}

class TodoViewModel: ObservableObject {
    private var notificationToken: NotificationToken?
    private var realm: Realm
    
    @Published var todoList: [Todo] = []
    @Published var mode: SectionTitle = .ALL 
    
    init() {
        realm = try! Realm()
        fetchTodos(current: mode)
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
    
    func updateContent(uuid: String? = nil, section: UpdateValue, newValueBool: Bool? = nil, newValueDate: Date? = nil, newValueString: String? = nil) {
        if section == .deleteAll {
            try! realm.write {
                let todos = realm.objects(Todo.self).where({ $0.isDelete == true })
                realm.delete(todos)
            }
        } else if let todo = realm.object(ofType: Todo.self, forPrimaryKey: uuid) {
            try! realm.write {
                switch section {
                case .title:
                    todo.todo  = newValueString ?? todo.todo
                case .isDelete:
                    todo.isDelete = true
                case .restore:
                    todo.isDelete = false
                case .isFavorite:
                    todo.isFavorite = newValueBool ?? !todo.isFavorite
                case .isComplete:
                    todo.isComplete = newValueBool ?? !todo.isComplete
                default: break
                }
            }
        }
    }
    
    func enabledPressDeleteButton() -> Bool {
        return realm.objects(Todo.self).where({ $0.isDelete == true }).isEmpty
    }

    deinit {
        notificationToken?.invalidate()
    }
}
