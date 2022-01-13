//
//  HomeView.swift
//  Project Iris
//
//  Created by Connor Barker on 2022-01-13.
//

import SwiftUI

struct HomeView: View {
    @State private var showImagePicker = false
    @State private var inputImage: UIImage?

    @State private var currentButton: Int = 1
    private var actionButtons: [Int:String] = [
        1:"scan\ntext",
        2:"detect\nbill",
        3:"detect\ncolor"
    ]
    
    var body: some View {
        AppThemeContainer(pageTitle: "home", home: true) {
            ButtonCarouselView(buttons: actionButtons, currentButton: $currentButton, showImagePicker: $showImagePicker)

            Button {
                currentButton = currentButton == actionButtons.count ? 1 : currentButton + 1
            } label: {
                Text("\($currentButton.wrappedValue)/\(actionButtons.count)")
            }
            .buttonStyle(PageButton())
            .accessibilityHidden(true)
        }
        .sheet(isPresented: $showImagePicker, onDismiss: processImage) {
            ImagePicker(image: $inputImage)
        }
    }

    private func processImage() {

    }
}
