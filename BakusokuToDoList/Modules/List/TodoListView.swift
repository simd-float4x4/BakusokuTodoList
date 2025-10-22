//
//  TodoListView.swift
//  BakusokuToDoList
//
//  Created by Shumpei Horiuchi on 2025/10/20.
//

import UIKit
import SwiftUI
import RealmSwift

struct TodoListView: View {
    @StateObject var viewModel = TodoViewModel()
    @State var activeSectionTitle: SectionTitle = .ALL
    @State var selectedUUID: String = ""
    @State var isShowAlert = false
    @State var isDeleteBegun = false
    @State var showAlert = false
    @State var editedText = ""
    let blue800 = Color.getRawColor(hex: "0031D8")
        
    var body: some View {
        ZStack {
            contentView
            if isDeleteBegun {
                Color.black.opacity(0.8)
                    .ignoresSafeArea()
                ProgressView()
                    .tint(.white)
                    .scaleEffect(3)
            }
        }
    }
    
    var contentView: some View {
        NavigationStack {
            VStack(spacing: 0) {
                navigationHeader()
                if activeSectionTitle == .CURRENTLY_DETLETED {
                    DeleteAllButtonComponents(
                        buttonText: "全て削除する",
                        isEnabled: viewModel.enabledPressDeleteButton(),
                        onVoid: {
                            isShowAlert = true
                        }
                    )
                    .alert("最近削除したタスクを本当に削除しますか？", isPresented: $isShowAlert) {
                        Button("キャンセル", role: .cancel) {
                            isShowAlert = false
                        }
                        Button("完全に削除する", role: .destructive) {
                            isShowAlert = false
                            isDeleteBegun = true
                            Task {
                                viewModel.deleteAllTodo()
                            }
                            isDeleteBegun = false
                            viewModel.reloadData()
                        }
                    } message: {
                        Text("この操作は元に戻せません。")
                    }
                    .padding()
                }
                
                ZStack(alignment: .bottomTrailing) {
                    ScrollView {
                        LazyVStack(spacing: 8) {
                            ForEach(viewModel.todoList, id: \.uuid) { item in
                                ZStack(alignment: .trailing) {
                                    HStack(spacing: 8) {
                                        TodoEditButton(onEdit: {
                                            editedText = item.todo
                                            showAlert = true
                                            selectedUUID = item.uuid
                                        })
                                        Spacer()
                                        if activeSectionTitle == .CURRENTLY_DETLETED {
                                            TodoRestoreButton(onRestore: {
                                                let realm = try! Realm()
                                                if let todo = realm.object(ofType: Todo.self, forPrimaryKey: item.uuid) {
                                                    try! realm.write {
                                                        todo.isDelete = false
                                                    }
                                                }
                                            })
                                        } else {
                                            TodoDeleteButton(onDelete: {
                                                let realm = try! Realm()
                                                if let todo = realm.object(ofType: Todo.self, forPrimaryKey: item.uuid) {
                                                    try! realm.write {
                                                        todo.isDelete = true
                                                    }
                                                }
                                            })
                                        }
                                    }

                                    CheckBoxButtonCards(
                                        isChecked: item.isComplete,
                                        isFavorite: item.isFavorite,
                                        buttonText: item.todo,
                                        onVoid: {
                                            let realm = try! Realm()
                                            if let todo = realm.object(ofType: Todo.self, forPrimaryKey: item.uuid) {
                                                try! realm.write {
                                                    let current = todo.isComplete
                                                    todo.isComplete = !current
                                                    todo.completedAt = Date()
                                                }
                                            }
                                        },
                                        onFavoriteVoid: {
                                            let realm = try! Realm()
                                            if let todo = realm.object(ofType: Todo.self, forPrimaryKey: item.uuid) {
                                                try! realm.write {
                                                    todo.isFavorite = !item.isFavorite
                                                }
                                            }
                                        }
                                    )
                                }
                            }
                            .alert("", isPresented: $showAlert) {
                                TextField("更新されたToDoを入力", text: $editedText)
                                Button("更新") {
                                    Task {
                                        viewModel.updateTodoContent(uuid: selectedUUID, updatedText: editedText)
                                        viewModel.reloadData()
                                    }
                                    showAlert = false
                                    viewModel.fetchTodos(current: activeSectionTitle)
                                }
                                Button("キャンセル", role: .cancel) {
                                    showAlert = false
                                }
                            } message: {
                                Text("タスクを更新してください。")
                            }
                        }
                        .padding()
                        
                        Spacer()
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .padding()
                    }
                    
                    NavigationLink(destination: CreateTodoView()) {
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 56, height: 56)
                                .shadow(radius: 4)

                            Image(systemName: "plus")
                                .font(.title3)
                                .foregroundColor(blue800)
                        }
                    }
                    .padding()
                }
            }
        }
    }
}
