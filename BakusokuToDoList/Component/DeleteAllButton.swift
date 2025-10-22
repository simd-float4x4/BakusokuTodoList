//
//  DeleteAllButton.swift
//  BakusokuToDoList
//
//  Created by Shumpei Horiuchi on 2025/10/22.
//

import Foundation
import SwiftUI

struct DeleteAllButtonComponents: View {
    @State var buttonText: String
    @State var isEnabled: Bool
    
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
        .disabled(isEnabled)
        .frame(maxWidth: .infinity)
        .frame(maxHeight: 48)
        .accentColor(.white)
        .background(isEnabled == true ? .gray : .red )
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
