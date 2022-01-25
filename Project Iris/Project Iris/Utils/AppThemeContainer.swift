//
//  AppView.swift
//  Project Iris
//
//  Created by Connor Barker on 2022-01-13.
//

import SwiftUI

@available(iOS 15.0, *)
struct AppThemeContainer <Content : View> : View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var content : Content
    var pageTitle : String
    var home : Bool

    init(pageTitle: String, home: Bool, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.pageTitle = pageTitle
        self.home = home
        UINavigationBar.appearance().backgroundColor = UIColor(Color("appWhite"))
    }

    var body: some View {
        ZStack {
            Color("appWhite")
                .edgesIgnoringSafeArea(.top)
                .accessibilityHidden(true)
            Color("appBlack")
                .edgesIgnoringSafeArea(.bottom)
                .accessibilityHidden(true)
            VStack {
                ZStack {
                    Color("appWhite")
                        .edgesIgnoringSafeArea(.top)
                        .accessibilityHidden(true)
                    if (home) {
                        NavigationLink(destination: SettingsView()) {
                            Image(systemName: "gearshape.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .imageScale(.large)
                                .frame(width: 40, height: 40)
                                .position(x: 40, y: 35)
                        }
                        .buttonStyle(OnPressButtonStyle())
                        .accessibilityLabel(Text("settings"))
                        .accessibilitySortPriority(1)
                    } else {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image(systemName: "chevron.down")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .imageScale(.small)
                                .frame(width: 20, height: 20)
                                .position(x: 35, y: 35)
                        }
                        .buttonStyle(OnPressButtonStyle())
                        .accessibilityLabel(Text("back"))
                        .accessibilitySortPriority(1)
                    }
                    
                    Text(pageTitle)
                        .foregroundColor(Color("appBlack"))
                        .font(Font.custom("Roboto-Black", size: 36))
                        .accessibility(sortPriority: 10)
                        .accessibilityLabel(Text(pageTitle + " page"))
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 70)
                .padding(.bottom, 15)

                VStack {
                    content
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .navigationBarHidden(true)
    }
}
