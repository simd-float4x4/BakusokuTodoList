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
            HStack(spacing: 0) {
                ForEach(SectionTitle.allCases, id: \.self) { title in
                    ZStack(alignment: .center) {
                        VStack(spacing: 0) {
                            Rectangle()
                                .fill(activeSectionTitle == title ? AnyShapeStyle(.mint.opacity(0.3)) : AnyShapeStyle(.ultraThinMaterial))
                                .frame(height: 43)
                            Rectangle()
                                .fill(activeSectionTitle == title ? .mint : .gray)
                                .frame(height: 5)
                        }
                        .frame(minWidth: 78)
                        .border(.black.opacity(0.2), width: 1)
                        
                        Text(title.titleText)
                            .padding()
                    }
                    .onTapGesture {
                        activeSectionTitle = title
                        viewModel.mode = title
                    }
                }
            }
        }
    }
}
