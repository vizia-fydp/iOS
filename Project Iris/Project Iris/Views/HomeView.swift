//
//  HomeView.swift
//  Project Iris
//
//  Created by Connor Barker on 2022-01-13.
//

import SwiftUI
import UIKit

@available(iOS 15.0, *)
struct HomeView: View {
    @State private var currentButton: Int = 1
    @State private var showSheet: Bool = false
    private var actionButtons: [Int:String] = [
        1:"scan\ntext",
        2:"detect\nbill",
        3:"detect\ncolor"
    ]
    
    var body: some View {
        AppThemeContainer(pageTitle: "home", home: true) {
            ButtonCarouselView(buttons: actionButtons, currentButton: $currentButton, showSheet: $showSheet)

            Button {
                currentButton = currentButton == actionButtons.count ? 1 : currentButton + 1
            } label: {
                Text("\($currentButton.wrappedValue)/\(actionButtons.count)")
            }
            .buttonStyle(PageButton())
            .accessibilityHidden(true)
        }.sheet(isPresented: $showSheet) {
            HalfSheet {
                PlaybackView()
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}
