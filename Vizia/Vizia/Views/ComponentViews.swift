//
//  ComponentViews.swift
//  Project Iris
//
//  Created by Connor Barker on 2022-01-13.
//

import SwiftUI

// Card style button (home page)
struct PrimaryButton: ButtonStyle {
    @Binding var currentButton: Int
    var totalButtons: Int
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                ZStack {
                    Color("appWhite")
                    HStack(spacing: 180) {
                        Button {
                            if ($currentButton.wrappedValue == 1) {
                                self.currentButton = self.totalButtons
                            } else {
                                self.currentButton = self.currentButton - 1
                            }
                        } label: {
                            Image(systemName: "chevron.left")
                                .imageScale(.large)
                        }
                        .buttonStyle(ChevronButton())
                        
                        Button {
                            if ($currentButton.wrappedValue == self.totalButtons) {
                                self.currentButton = 1
                            } else {
                                self.currentButton = self.currentButton + 1
                            }
                        } label: {
                            Image(systemName: "chevron.right")
                                .imageScale(.large)
                        }
                        .buttonStyle(ChevronButton())
                    }
                }
            )
            .cardStyle()
    }
}

// Numbered pagination button
struct PageButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: 90, maxHeight: 55)
            .background(Color("appWhite"))
            .font(Font.custom("Roboto-Black", size: 36))
            .clipShape(RoundedRectangle(cornerRadius: 5.0))
            .buttonStyle(OnPressButtonStyle())
    }
}

// Chevron style pagination button
struct ChevronButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 20)
            .padding(.vertical, 30)
            .buttonStyle(OnPressButtonStyle())
    }
}

// Container for home page buttons
struct ButtonCarouselView: View {
    @Binding var showImagePicker: Bool
    @Binding var currentButton: Int
    @Binding var speech: Speech
    var buttons : [Int: String]
    
    init(buttons: [Int: String], currentButton: Binding<Int>, showImagePicker: Binding<Bool>, speech: Binding<Speech>) {
        self._currentButton = currentButton
        self._showImagePicker = showImagePicker
        self._speech = speech
        self.buttons = buttons
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(Color("appBlack"))
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.3)
    }

    var body: some View {
        if #available(iOS 15.0, *) {
            TabView(selection: self.$currentButton) {
                ForEach(1..<(self.buttons.count + 1)) { i in
                    Button(self.buttons[i] ?? "default") {
                        self.showImagePicker = true
                    }
                    .buttonStyle(PrimaryButton(currentButton: $currentButton, totalButtons: self.buttons.count))
                    .buttonStyle(OnPressButtonStyle())
                    .tag(i)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .tabViewStyle(PageTabViewStyle())
            .animation(.easeInOut)
            .transition(.slide)
            // Different layout when voiceover is activated, don't use TabView since it
            // doesn't work well with voiceover
            .accessibilityChildren {
                ForEach(1..<(self.buttons.count + 1)) { i in
                    Button(self.buttons[i] ?? "default") {
                        self.currentButton = i
                        self.showImagePicker = true
                    }
                }
            }
            .accessibilitySortPriority(9)
        }
    }
}
