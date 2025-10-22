//
//  ToDoRestoreButton.swift
//  BakusokuToDoList
//
//  Created by Shumpei Horiuchi on 2025/10/22.
//

import UIKit
import SwiftUI
import RealmSwift

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
