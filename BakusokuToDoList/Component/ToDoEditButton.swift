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
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    let onEdit: () -> Void
    let blue800 = Color.getRawColor(hex: "0031D8")
    let blue200 = Color.getRawColor(hex: "C5D7FB")

    var body: some View {
        Image(systemName: "pencil")
            .font(.title3)
            .foregroundColor(colorScheme == .light ? blue800 : blue200)
            .contentShape(Rectangle())
            .onTapGesture {
                onEdit()
            }
    }
}
