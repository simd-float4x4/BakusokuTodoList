//
//  TodoListView.swift
//  BakusokuToDoList
//
//  Created by Shumpei Horiuchi on 2025/10/20.
//

import SwiftUI
import RealmSwift

enum SectionTitle: CaseIterable {
    case ALL
    case NORMAL
    case CHECKED
    case CURRENTLY_DETLETED
    
    var titleText: String {
        switch self {
        case .ALL: return "すべて"
        case .NORMAL: return "未達成"
        case .CHECKED: return "チェック済"
        case .CURRENTLY_DETLETED: return "最近削除した項目"
        }
    }
}

struct TodoListView: View {
    @StateObject private var viewModel = TodoViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(SectionTitle.allCases, id: \.self) { title in
                        ZStack(alignment: .center) {
                            VStack(spacing: 0) {
                                Rectangle()
                                    .fill(.ultraThinMaterial)
                                    .frame(height: 43)
                                Rectangle()
                                    .frame(height: 5)
                            }
                            .frame(minWidth: 78)
                            .border(.black.opacity(0.2), width: 1)
                            Text(title.titleText)
                                .padding()
                        }
                    }
                }
            }
            
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
