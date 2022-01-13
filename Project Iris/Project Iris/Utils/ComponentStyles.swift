//
//  ComponentStyles.swift
//  Project Iris
//
//  Created by Connor Barker on 2022-01-13.
//

import SwiftUI

struct OnPressButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(configuration.isPressed ? Color("accentGrey") : Color("appBlack"))
    }
}

struct CardButtonStyle: ButtonStyle {
    var height: CGFloat
    
    init(height: CGFloat) {
        self.height = height
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                ZStack {
                    Color("appWhite")
                }
            )
            .font(Font.custom("Roboto-Black", size: 48))
            .clipShape(RoundedRectangle(cornerRadius: 5.0))
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: self.height)
            .padding(.horizontal, 30)
            .padding(.vertical, 15)
            .foregroundColor(configuration.isPressed ? Color("accentGrey") : Color("appBlack"))
    }
}
