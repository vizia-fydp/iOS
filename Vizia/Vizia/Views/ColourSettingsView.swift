//
//  ColourSettingsView.swift
//  Project Iris
//
//  Created by Connor Barker on 2022-01-13.
//

import SwiftUI

@available(iOS 15.0, *)
struct ColourSettingsView: View {
    var body: some View {
        AppThemeContainer(pageTitle: "colour settings", home: false) {
            VStack {
                Button {
                    print("colour")
                } label: {
                    Text("Colour")
                }
                .buttonStyle(CardButtonStyle(height: 100))
                
                Button {
                    print("invert")
                } label: {
                    Text("Invert")
                }
                .buttonStyle(CardButtonStyle(height: 100))
                
                Spacer()
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        }
    }
}
