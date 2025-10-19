//
//  ContentView.swift
//  BakusokuToDoList
//
//  Created by Shumpei Horiuchi on 2025/10/19.
//

import SwiftUI
import RealmSwift

struct ContentView: View {
    let sampleTodo = ["これはサンプルのTodoです。", "これは長文のTodoになる予定です。これは長文のTodoになる予定です。これは長文のTodoになる予定です。"]
    @StateObject private var viewModel = TodoViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    ForEach(viewModel.todoList, id: \.uuid) { item in
                        ZStack(alignment: .trailing)
                        {
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
                                isChecked: false,
                                buttonText: item.todo
                            )
                            .onTapGesture {
                                let realm = try! Realm()
                                if let todo = realm.object(ofType: Todo.self, forPrimaryKey: item.uuid) {
                                    try! realm.write {
                                        todo.completedAt = Date()
                                    }
                                }
                            }
                        }
                    }
                    Spacer()
                }
                .padding()
                NavigationLink(destination: SecondView()) {
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
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            }
            .navigationTitle("Todo")
        }
    }
}


struct SecondView: View {
    @State private var text: String = ""
    @FocusState var focus: Bool
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
           TextEditor(text: $text)
               .focused($focus)
               .padding(4)
               .frame(maxWidth: .infinity)
               .frame(maxHeight: .infinity)
               .overlay(
                   RoundedRectangle(cornerRadius: 8)
                       .stroke(Color.gray, lineWidth: 3)
               )
               .padding(.bottom, 16)
            
            ButtonComponents(buttonText: "登録する") {
                var array = Array(text.components(separatedBy: "\n"))
                array.removeAll(where: { (value) in
                    value == ""
                })
                Task {
                    let realm = try! Realm()
                    for i in 0 ..< array.count {
                        let todo = Todo(todo: array[i])
                        try! realm.write {
                            realm.add(todo)
                        }
                    }
                    dismiss()
                }
            }
        }
        .padding()
        .onTapGesture {
            focus = false
        }
    }
}

#Preview {
    ContentView()
}
