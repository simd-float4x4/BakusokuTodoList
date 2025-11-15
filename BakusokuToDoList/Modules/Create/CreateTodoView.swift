//
//  CreateTodoView.swift
//  BakusokuToDoList
//
//  Created by Shumpei Horiuchi on 2025/10/20.
//

import SwiftUI
import RealmSwift

struct CreateTodoView: View {
    @State private var text: String = ""
    @FocusState var focus: Bool
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
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
                
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("ここにやることを登録してください。", comment: "Placeholder text for todo input")
                    Text("改行をして入力することで、一度にまとめてTodoカードを作成できます。", comment: "Instruction about multi-line input")
                    Text("※行頭記号は不要です。", comment: "Note about no need for bullet points")
                    Spacer()
                        .frame(height: 20)
                    Text("例）", comment: "Example label")
                    Text("TOEICの問題集P358~388を進める", comment: "Example todo item 1")
                    Text("火曜日に鶏肉と牛乳を買う", comment: "Example todo item 2")
                    Text("銀行の振り込みに行く", comment: "Example todo item 3")
                    Text("抽選登録の申し込みを忘れない", comment: "Example todo item 4")
                    Text("クライアントへ見積もりを送付する", comment: "Example todo item 5")
                    Spacer()
                }
                .opacity(text.isEmpty ? 0.5 : 0.0)
                .allowsHitTesting(false)
                .padding(10)
            }
           
            
            ButtonComponents(buttonText: String(localized: "登録する", comment: "Register button text")) {
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
