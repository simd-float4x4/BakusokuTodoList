//
//  ToDoDeleteButton.swift
//  BakusokuToDoList
//
//  Created by Shumpei Horiuchi on 2025/10/22.
//

import UIKit
import SwiftUI
import RealmSwift

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
