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
            results = results.filter("isDelete == false")
        case .CHECKED:
            results = results.filter("isComplete == true")
        case .CURRENTLY_DETLETED:
            results = results.filter("isDelete == true")
        case .NORMAL:
            results = results.filter("isComplete == false")
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

    deinit {
        notificationToken?.invalidate()
    }
}
