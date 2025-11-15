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
    @State private var isPressed = false
    @State private var isLongPressed = false
    @State private var pressedID: String? = nil
    @State private var dragOffset: CGFloat = 0
    private let swipeThreshold: CGFloat = 100
    @AppStorage("isShakingEnabled") private var isShakingEnabled: Bool = true
    
    let blue50 = Color.getRawColor(hex: "E8F1FE")
    let blue200 = Color.getRawColor(hex: "C5D7FB")
    let blue1000 = Color.getRawColor(hex: "00118F")
    let blue800 = Color.getRawColor(hex: "0031D8")
    let blue100 = Color.getRawColor(hex: "D9E6FF")
    let gray800 = Color.getRawColor(hex: "333333")
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 0) {
                    navigationHeader()
                    if activeSectionTitle != .SETTING {
                        contentView
                    } else {
                        settingView
                    }
                    if isDeleteBegun {
                        Color.black.opacity(0.8)
                            .ignoresSafeArea()
                        ProgressView()
                            .tint(.white)
                            .scaleEffect(3)
                    }
                }
            }
        }
    }
    
    func hapticAndSound() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        // AudioServicesPlaySystemSound(1520)
    }
    
    var settingView: some View {
        VStack(spacing: 0) {
            SettingButtonCards(buttonText: "端末の振動を許可する")
            Spacer()
            
        }
        .padding()
    }

    var contentView: some View {
        VStack(spacing: 0) {
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
                            viewModel.updateContent(section: .deleteAll)
                        }
                        isDeleteBegun = false
                    }
                } message: {
                    Text("この操作は元に戻せません。")
                }
                .padding()
                .padding(.top, 16)
            }
            
            ZStack(alignment: .bottomTrailing) {
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(viewModel.todoList, id: \.uuid) { item in
                            let isPressed = (pressedID == item.uuid)
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
                                            viewModel.updateContent(uuid: item.uuid, section: .restore)
                                        })
                                    } else {
                                        TodoDeleteButton(onDelete: {
                                            viewModel.updateContent(uuid: item.uuid, section: .isDelete)
                                        })
                                    }
                                }

                                CheckBoxButtonCards(
                                    isChecked: item.isComplete,
                                    isLongTapped: $isLongPressed,
                                    isFavorite: item.isFavorite,
                                    buttonText: item.todo,
                                    onVoid: {
                                        viewModel.updateContent(uuid: item.uuid, section: .isComplete, newValueBool: !item.isComplete)
                                    },
                                    onFavoriteVoid: {
                                        viewModel.updateContent(uuid: item.uuid, section: .isFavorite, newValueBool: !item.isFavorite)
                                    }
                                )
                                .scaleEffect(isPressed ? 1.1 : 1.0)
                                .animation(.spring(response: 0.2, dampingFraction: 0.5), value: isPressed)
                                .onLongPressGesture(minimumDuration: 1.5, pressing: { pressing in
                                    withAnimation {
                                        isLongPressed = pressing
                                        pressedID = pressing ? item.uuid : nil
                                        let isShakingEnabled = SettingSharedManager.shared.getShakingEnabledStatus()
                                        if isShakingEnabled && pressing {
                                            hapticAndSound()
                                        }
                                    }
                                }, perform: {})
                            }
                        }
                        .alert("", isPresented: $showAlert) {
                            TextField("更新されたToDoを入力", text: $editedText)
                            Button("更新") {
                                viewModel.updateContent(uuid: selectedUUID, section: .title, newValueString: editedText)
                                showAlert = false
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
                        .frame(height: 120)
                        .padding()
                }
                
                VStack(spacing: 4) {
                    Button {
                        viewModel.toggleFilteredTodos(activeSectionTitle: activeSectionTitle)
                    } label: {
                        ZStack {
                            Circle()
                                .fill(blue800)
                                .frame(width: 56, height: 56)
                                .shadow(radius: 4)

                            Image(systemName: "arrow.up.arrow.down")
                                .font(.title3)
                                .foregroundColor(Color.white)
                        }
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
