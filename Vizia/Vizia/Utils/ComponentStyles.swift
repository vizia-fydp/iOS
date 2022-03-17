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
    var square: Bool

    init(height: CGFloat, square: Bool = false) {
        self.height = height
        self.square = square
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
            .frame(minWidth: 0, maxWidth: self.square ? self.height : .infinity, minHeight: 0, maxHeight: self.height)
            .padding(.horizontal, self.square ? 0 : 30)
            .padding(.vertical, self.square ? 0 : 15)
            .foregroundColor(configuration.isPressed ? Color("accentGrey") : Color("appBlack"))
    }
}
