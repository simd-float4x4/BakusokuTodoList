//
//  SettingButtonCards.swift
//  BakusokuToDoList
//
//  Created by Shumpei Horiuchi on 2025/10/28.
//

import SwiftUI

struct SettingButtonCards: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @State var isEnabledShaking: Bool = false
    let buttonText: String
  
    let blue50 = Color.getRawColor(hex: "E8F1FE")
    let blue200 = Color.getRawColor(hex: "C5D7FB")
    let blue1000 = Color.getRawColor(hex: "00118F")
    let blue800 = Color.getRawColor(hex: "0031D8")
    let blue100 = Color.getRawColor(hex: "D9E6FF")
    let gray800 = Color.getRawColor(hex: "333333")
    
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            Text(buttonText)
                .multilineTextAlignment(.leading)
                .foregroundColor(.primary)
                .bold()
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
            
            Toggle(isOn: $isEnabledShaking, label: {
                
            })
            .foregroundColor(colorScheme == .light ? blue800 : blue200)
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 48, alignment: .leading)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray, lineWidth: 3)
        )
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
