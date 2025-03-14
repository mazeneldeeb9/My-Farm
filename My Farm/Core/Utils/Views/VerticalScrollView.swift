//
//  VerticalScrollView.swift
//  3oon
//
//  Created by mazen eldeeb on 11/02/2025.
//


import SwiftUI

struct VerticalScrollView<Content: View>: View {

  // MARK: - Constants
  let content: () -> Content

  // MARK: - State Variables
  @State private var scrollViewHeight: CGFloat = 0.0
  @State private var contentHeight: CGFloat = 0.0
  init(@ViewBuilder _ content: @escaping () -> Content) {
    self.content = content
  }
    var body: some View {
        ScrollView(contentHeight > scrollViewHeight ? .vertical : [], showsIndicators: false) {
            content()
                .background(GeometryReader { geometry in
                    Color.clear
                        .onAppear {
                            contentHeight = geometry.size.height
                        }
                        .onChange(of: geometry.size.height) { newHeight in
                            contentHeight = newHeight
                        }
                })
        }.background(GeometryReader { geometry in
            Color.primaryGreen.ignoresSafeArea()
                .onAppear {
                    scrollViewHeight = geometry.size.height
                }
                .onChange(of: geometry.size.height) { newHeight in
                    scrollViewHeight = newHeight
                }
        })
    }
}
