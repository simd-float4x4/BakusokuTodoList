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
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    let onStar: () -> Void
    let isFavorite: Bool
    let blue200 = Color.getRawColor(hex: "C5D7FB")
    let blue800 = Color.getRawColor(hex: "0031D8")

    var body: some View {
        Image(systemName: isFavorite ? "star.fill" : "star")
            .font(.title3)
            .foregroundColor(colorScheme == .light ? blue800 : blue200)
            .contentShape(Rectangle())
            .onTapGesture {
                onStar()
            }
    }
}
