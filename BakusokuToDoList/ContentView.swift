//
//  ContentView.swift
//  BakusokuToDoList
//
//  Created by Shumpei Horiuchi on 2025/10/19.
//

import SwiftUI
import RealmSwift

struct SecondView: View {
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
                    Text("ここにやることを登録してください。")
                    Text("改行をして入力することで、一度にまとめてTodoカードを作成できます。")
                    Text("※行頭記号は不要です。")
                    Spacer()
                        .frame(height: 20)
                    Text("例）")
                    Text("TOEICの問題集P358~388を進める")
                    Text("火曜日に鶏肉と牛乳を買う")
                    Text("銀行の振り込みに行く")
                    Text("抽選登録の申し込みを忘れない")
                    Text("クライアントへ見積もりを送付する")
                    Spacer()
                }
                .opacity(text.isEmpty ? 0.5 : 0.0)
                .allowsHitTesting(false)
                .padding(4)
            }
           
            
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
    TodoListView()
}
