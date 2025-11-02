//
//  ButtonComponents.swift
//  BakusokuToDoList
//
//  Created by Shumpei Horiuchi on 2025/10/19.
//

import SwiftUI

struct CheckBoxButtonCards: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @State var isChecked: Bool = false
    @Binding var isLongTapped: Bool
    var isFavorite: Bool = false
    let buttonText: String
    
    @State private var dragOffset: CGFloat = 0
    private let maxSwipe: CGFloat = 50
    private let swipeThreshold: CGFloat = -25
    
    var onVoid: () -> Void
    var onFavoriteVoid: () -> Void

    let blue50 = Color.getRawColor(hex: "E8F1FE")
    let blue200 = Color.getRawColor(hex: "C5D7FB")
    let blue1000 = Color.getRawColor(hex: "00118F")
    let blue800 = Color.getRawColor(hex: "0031D8")
    let blue100 = Color.getRawColor(hex: "D9E6FF")
    let gray800 = Color.getRawColor(hex: "333333")
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                .foregroundColor(
                    colorScheme == .light ? blue1000 : blue100
                )
                .font(.title3)
                
            Text(buttonText)
                .multilineTextAlignment(.leading)
                .foregroundColor(.primary)
                .bold()
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
            
            TodoFavoriteButton(onStar: onFavoriteVoid, isFavorite: isFavorite)
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 48, alignment: .leading)
        .background(
            isChecked
            ? (colorScheme == .light ? blue200 : blue800)
            : (colorScheme == .light ? Color.white : gray800)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray, lineWidth: 3)
        )
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .offset(x: dragOffset)
        .onDisappear() {
            dragOffset = 0
        }
        .onTapGesture {
            if dragOffset == 0 {
                isChecked.toggle()
                onVoid()
            }
            dragOffset = 0
        }
        .gesture(
            DragGesture(minimumDistance: abs(swipeThreshold), coordinateSpace: .local)
                .onChanged { value in
                    if isLongTapped {
                        // 移動量が左にあると同時に-100でdragをストップ
                        if value.translation.width < 0 && dragOffset > -maxSwipe {
                            dragOffset = value.translation.width
                        }
                        // ちょっとスワイプで戻す
                        if value.translation.width > 0 && dragOffset < 0 {
                            dragOffset = 0
                        }
                        
                        // 移動量が左にあると同時に100でdragをストップ
                        if value.translation.width > 0 && dragOffset < maxSwipe {
                            dragOffset = value.translation.width
                        }
                        // ちょっとスワイプで戻す
                        if value.translation.width < 0 && dragOffset > 0 {
                            dragOffset = 0
                        }
                    }
                }
                .onEnded { value in
                    if abs(value.translation.width) < 5 {
                    } else if dragOffset < swipeThreshold {
                        withAnimation {
                            dragOffset = -maxSwipe
                        }
                    } else if dragOffset > swipeThreshold {
                        withAnimation {
                            dragOffset = maxSwipe
                        }
                    } else {
                        withAnimation {
                            dragOffset = 0
                        }
                    }
                }
        )
    }
}
