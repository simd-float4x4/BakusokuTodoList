//
//  ToDoFavoriteButton.swift
//  BakusokuToDoList
//
//  Created by Shumpei Horiuchi on 2025/10/22.
//

import UIKit
import SwiftUI
import RealmSwift

struct TodoFavoriteButton: View {
    let onStar: () -> Void
    let blue800 = Color.getRawColor(hex: "0031D8")
    let isFavorite: Bool

    var body: some View {
        Image(systemName: isFavorite ? "star.fill" : "star")
            .font(.title3)
            .foregroundColor(blue800)
            .contentShape(Rectangle())
            .onTapGesture {
                onStar()
            }
    }
}
