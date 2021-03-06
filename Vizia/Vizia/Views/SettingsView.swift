//
//  SettingsView.swift
//  Project Iris
//
//  Created by Connor Barker on 2022-01-13.
//

import SwiftUI

@available(iOS 15.0, *)
struct SettingsView: View {
    var body: some View {
        AppThemeContainer(pageTitle: "settings", home: false) {
            VStack {
                NavigationLink(destination: ColourSettingsView()) {
                    Text("general")
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                }
                .buttonStyle(CardButtonStyle(height: 100))
                .buttonStyle(OnPressButtonStyle())
                .accessibilitySortPriority(8)
                
                NavigationLink(destination: ColourSettingsView()) {
                    Text("playback")
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                }
                .buttonStyle(CardButtonStyle(height: 100))
                .buttonStyle(OnPressButtonStyle())
                .accessibilitySortPriority(8)
                
                NavigationLink(destination: ColourSettingsView()) {
                    Text("font")
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                }
                .buttonStyle(CardButtonStyle(height: 100))
                .buttonStyle(OnPressButtonStyle())
                .accessibilitySortPriority(8)
                
                NavigationLink(destination: ColourSettingsView()) {
                    Text("colour")
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                }
                .buttonStyle(CardButtonStyle(height: 100))
                .buttonStyle(OnPressButtonStyle())
                .accessibilitySortPriority(8)
                
                Spacer()
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        }
    }
}
