//
//  ButtonComponents.swift
//  BakusokuToDoList
//
//  Created by Shumpei Horiuchi on 2025/10/19.
//

import SwiftUI

struct ButtonComponents: View {
    @State var buttonText: String
    var onVoid: () -> Void
    
    var body: some View {
        Button(action: {
            onVoid()
        }) {
            Text(buttonText)
                .bold()
                .frame(maxWidth: .infinity, maxHeight: 48)
                .contentShape(Rectangle())
        }
        .frame(maxWidth: .infinity)
        .frame(maxHeight: 48)
        .accentColor(.white)
        .background(Color.getRawColor(hex: "0017C1"))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct CheckBoxButtonCards: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @State var isChecked: Bool = false
    @State var buttonText: String
    
    @State private var dragOffset: CGFloat = 0
    private let maxSwipe: CGFloat = 50
    private let swipeThreshold: CGFloat = -25
    
    var onVoid: () -> Void

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
        .onTapGesture {
            if dragOffset == 0 {
                isChecked.toggle()
                onVoid()
            }
            dragOffset = 0
        }
        .offset(x: dragOffset)
        .gesture(
            DragGesture(minimumDistance: abs(swipeThreshold), coordinateSpace: .local)
                .onChanged { value in
                    if value.translation.width < 0 && dragOffset > -maxSwipe {
                        dragOffset = value.translation.width
                    }
                    
                    if value.translation.width > 0 && dragOffset < 0 {
                        dragOffset = 0
                    }
                }
                .onEnded { value in
                    if abs(value.translation.width) < 5 {
                    } else if dragOffset < swipeThreshold {
                        withAnimation {
                            dragOffset = -maxSwipe
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

extension Color {
    static func getRawColor(hex: String) -> Color {
        var red = 0
        var green = 0
        var blue = 0
        if let hexNumber = Int(hex, radix: 16) {
            red = (hexNumber >> 16) & 0xFF
            green = (hexNumber >> 8) & 0xFF
            blue = hexNumber & 0xFF
        }
        return Color(
            red: Double(red) / 255.0,
            green: Double(green) / 255.0,
            blue: Double(blue) / 255.0,
            opacity: 1.0
        )
    }
}
