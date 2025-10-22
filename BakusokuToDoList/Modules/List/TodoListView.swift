//
//  TodoListView.swift
//  BakusokuToDoList
//
//  Created by Shumpei Horiuchi on 2025/10/20.
//

import UIKit
import SwiftUI
import RealmSwift

enum SectionTitle: CaseIterable {
    case STAR
    case ALL
    case NORMAL
    case CHECKED
    case CURRENTLY_DETLETED
    
    var titleText: String {
        switch self {
        case .STAR: return "★"
        case .ALL: return "すべて"
        case .NORMAL: return "未達成"
        case .CHECKED: return "チェック済"
        case .CURRENTLY_DETLETED: return "最近削除した項目"
        }
    }
}

struct TodoDeleteButton: View {
    let onDelete: () -> Void

    var body: some View {
        Image(systemName: "trash")
            .font(.title3)
            .foregroundColor(.red)
            .contentShape(Rectangle())
            .onTapGesture {
                onDelete()
            }
    }
}

struct TodoFavoriteButton: View {
    let onStar: () -> Void
    let starYellow = Color.getRawColor(hex: "FFDC00")
    let isFavorite: Bool

    var body: some View {
        Image(systemName: isFavorite ? "star.fill" : "star")
            .font(.title3)
            .foregroundColor(starYellow)
            .contentShape(Rectangle())
            .onTapGesture {
                onStar()
            }
    }
}

struct TodoEditButton: View {
    let onEdit: () -> Void
    let blue800 = Color.getRawColor(hex: "0031D8")
    var body: some View {
        Image(systemName: "pencil")
            .font(.title3)
            .foregroundColor(blue800)
            .contentShape(Rectangle())
            .onTapGesture {
                onEdit()
            }
    }
}

struct TodoRestoreButton: View {
    let onRestore: () -> Void
    let blue800 = Color.getRawColor(hex: "0031D8")

    var body: some View {
        Image(systemName: "arrow.triangle.2.circlepath")
            .font(.title3)
            .foregroundColor(blue800)
            .contentShape(Rectangle())
            .onTapGesture {
                onRestore()
            }
    }
}

struct TodoListView: View {
    @StateObject private var viewModel = TodoViewModel()
    @State private var activeSectionTitle: SectionTitle = .ALL
    @State private var isShowAlert = false
    @State private var isDeleteBegun = false
    @State private var showAlert = false
    @State private var editedText = ""
    let blue800 = Color.getRawColor(hex: "0031D8")
        
    var body: some View {
        ZStack {
            contentView
            if isDeleteBegun {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                ProgressView()
            }
        }
    }
    
    
    var contentView: some View {
        NavigationStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(SectionTitle.allCases, id: \.self) { title in
                        ZStack(alignment: .center) {
                            VStack(spacing: 0) {
                                Rectangle()
                                    .fill(activeSectionTitle == title ? AnyShapeStyle(.mint.opacity(0.3)) : AnyShapeStyle(.ultraThinMaterial))
                                    .frame(height: 43)
                                Rectangle()
                                    .fill(activeSectionTitle == title ? .mint : .gray)
                                    .frame(height: 5)
                            }
                            .frame(minWidth: 78)
                            .border(.black.opacity(0.2), width: 1)
                            
                            Text(title.titleText)
                                .padding()
                        }
                        .onTapGesture {
                            activeSectionTitle = title
                            viewModel.mode = title
                        }
                    }
                }
            }
            
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
                        viewModel.deleteAllTodo()
                        isDeleteBegun = false
                    }
                } message: {
                    Text("この操作は元に戻せません。")
                }
                .padding()
            }
            
            ZStack(alignment: .bottomTrailing) {
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.todoList, id: \.uuid) { item in
                            ZStack(alignment: .trailing) {
                                HStack(spacing: 8) {
                                    TodoEditButton(onEdit: {
                                        editedText = item.todo
                                        showAlert = true
                                    })
//                                    .sheet(isPresented: $showAlert) {
//                                        VStack(spacing: 20) {
//                                            Text("タスクを更新する")
//                                            TextField("", text: $editedText)
//                                                .textFieldStyle(.roundedBorder)
//                                                .padding()
//                                            HStack {
//                                                Button("キャンセル") { showAlert = false }
//                                                Button("更新") {
//                                                    let realm = try! Realm()
//                                                    if let todo = realm.object(ofType: Todo.self, forPrimaryKey: item.uuid) {
//                                                        try! realm.write {
//                                                            todo.todo = editedText
//                                                        }
//                                                    }
//                                                    showAlert = false
//                                                }
//                                            }
//                                        }
//                                        .padding()
//                                    }
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
                        Spacer()
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
                            .resizable()
                            .scaledToFit()
                            .frame(width: 32, height: 32)
                            .foregroundColor(blue800)
                    }
                }
                .padding()
            }
        }
    }
}
