//
//  TodoListView.swift
//  BakusokuToDoList
//
//  Created by Shumpei Horiuchi on 2025/10/20.
//

import SwiftUI
import RealmSwift

struct TodoListView: View {
    @StateObject private var viewModel = TodoViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                ScrollView {
                    VStack {
                        ForEach(viewModel.todoList, id: \.uuid) { item in
                            ZStack(alignment: .trailing) {
                                Image(systemName: "trash")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 32, height: 32)
                                    .foregroundColor(.red)
                                    .onTapGesture {
                                        let realm = try! Realm()
                                        if let todo = realm.object(ofType: Todo.self, forPrimaryKey: item.uuid) {
                                            try! realm.write {
                                                todo.isDelete = true
                                            }
                                        }
                                    }

                                CheckBoxButtonCards(
                                    isChecked: item.isComplete,
                                    buttonText: item.todo,
                                    onVoid: {
                                        let realm = try! Realm()
                                        if let todo = realm.object(ofType: Todo.self, forPrimaryKey: item.uuid) {
                                            try! realm.write {
                                                let current = todo.isComplete
                                                todo.isComplete = !current
                                                print("tapされた: ", todo.isComplete)
                                                todo.completedAt = Date()
                                            }
                                        }
                                    }
                                )
                            }
                        }
                        Spacer()
                    }
                    .padding()
                }

                NavigationLink(destination: CreateTodoView()) {
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 56, height: 56)
                            .shadow(radius: 4)

                        Image(systemName: "plus")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 32, height: 32)
                            .foregroundColor(.blue)
                    }
                }
                .padding()
            }
        }
    }
}
