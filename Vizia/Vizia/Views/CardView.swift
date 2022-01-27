//
//  CardView.swift
//  Project Iris
//
//  Created by Connor Barker on 2022-01-13.
//

import SwiftUI

// Accepts "height" as an explicit argument
// Code for any generic "card" style item (non-button)
struct Card <Content : View> : View {
    var content : Content
    var height: Int
    
    init(height: Int, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.height = height
    }
    
    var body: some View {
        ZStack {
            Color("appWhite")
            content
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: CGFloat(self.height))
        .cardStyle()
    }
}
