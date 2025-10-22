//
//  Button.swift
//  BakusokuToDoList
//
//  Created by Shumpei Horiuchi on 2025/10/22.
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
