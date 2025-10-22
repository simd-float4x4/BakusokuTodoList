//
//  ToDoEditButton.swift
//  BakusokuToDoList
//
//  Created by Shumpei Horiuchi on 2025/10/22.
//

import UIKit
import SwiftUI
import RealmSwift

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
