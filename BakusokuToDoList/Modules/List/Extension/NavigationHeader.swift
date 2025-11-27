//
//  NavigationHeader.swift
//  BakusokuToDoList
//
//  Created by Shumpei Horiuchi on 2025/10/22.
//

import SwiftUI
import Foundation

extension TodoListView {
    func navigationHeader() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(SectionTitle.allCases, id: \.self) { title in
                    Text(title.titleText)
                        .font(.callout)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .foregroundStyle(
                            activeSectionTitle == title ? .white : colorScheme != .light ? .white : .black
                        )
                        .background(
                            activeSectionTitle == title ? blue800 : colorScheme == .light ? .white : .black
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(activeSectionTitle == title  ? blue800 : blue200, lineWidth: 1)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                        .onTapGesture {
                            activeSectionTitle = title
                            viewModel.mode = title
                            viewModel.fetchTodos(current: title)
                        }
                        .overlay() {
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.gray, lineWidth: 2)
                        }
                }
            }
            .padding(.bottom, 2)
        }
    }
}
