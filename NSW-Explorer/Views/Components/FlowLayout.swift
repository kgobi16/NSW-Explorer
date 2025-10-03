//
// FlowLayout.swift
//  NSW-Explorer
//
//  Created by Tlaitirang Rathete on 3/10/2025.


import SwiftUI

struct FlowLayout <Content: View>: View {
    let spacing: CGFloat
    let content: () -> Content
    
    init(spacing: CGFloat = 8, @ViewBuilder content: @escaping () -> Content) {
        self.spacing = spacing
        self.content = content
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: spacing) {
                // For now, just use a simple HStack for compatibility
                HStack {
                    content()
                    Spacer()
                }
            }
        }
    }
}
