//
//  ContentView.swift
//  Project Iris
//
//  Created by Connor Barker on 2021-10-24.
//

import SwiftUI

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
                        }
                        .buttonStyle(ChevronButton())
                    }
                }
            )
            .foregroundColor(.black)
            .font(Font.custom("Roboto-Black", size: 48))
            .clipShape(RoundedRectangle(cornerRadius: 5.0))
            .padding(.horizontal, 30)
            .padding(.vertical, 15)
            .multilineTextAlignment(.center)
    }
}

struct PageButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: 90, maxHeight: 55)
            .background(Color("appWhite"))
            .foregroundColor(.black)
            .font(Font.custom("Roboto-Black", size: 36))
            .clipShape(RoundedRectangle(cornerRadius: 5.0))
            .padding(.bottom, 15)
    }
}

struct ChevronButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 30)
            .padding(.vertical, 30)
    }
}

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
            Color("appBlack")
                .edgesIgnoringSafeArea(.bottom)
            VStack {
                ZStack {
                    Color("appWhite")
                        .edgesIgnoringSafeArea(.top)
                    Button(action: {
                        home ?
                        print("options") :
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: home ? "line.3.horizontal" : "chevron.left")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .imageScale(.small)
                            .foregroundColor(Color("appBlack"))
                            .frame(width: 20, height: 20)
                            .position(x: 45, y: 35)
                    }
                    Text(pageTitle)
                        .foregroundColor(Color("appBlack"))
                        .font(Font.custom("Roboto-Black", size: 36))
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

struct HomeView: View {
    @State private var currentButton: Int = 1
    private var actionButtons: [Int:String] = [
        1:"scan\ntext",
        2:"detect\nbill",
        3:"detect\ncolor"
    ]
    
    var body: some View {
        AppThemeContainer(pageTitle: "home", home: true) {
            ButtonCarouselView(buttons: actionButtons, currentButton: $currentButton)

            Button {
                currentButton = currentButton == actionButtons.count ? 1 : currentButton + 1
            } label: {
                Text("\($currentButton.wrappedValue)/\(actionButtons.count)")
            }
            .buttonStyle(PageButton())
        }
    }
}

struct PlaybackView: View {
    var body: some View {
        AppThemeContainer(pageTitle: "playback", home: false) {
            Text("hiiii lol")
        }
    }
}

struct ButtonCarouselView: View {
    @Binding var currentButton: Int
    var buttons : [Int: String]
    
    init(buttons: [Int: String], currentButton: Binding<Int>) {
        self._currentButton = currentButton
        self.buttons = buttons
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(Color("appBlack"))
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.3)
    }
    
    var body: some View {
        TabView(selection: self.$currentButton) {
            ForEach(1..<(self.buttons.count + 1)) { i in
                NavigationLink(destination: PlaybackView()) {
                    Text(self.buttons[i] ?? "default")
                }
                .buttonStyle(PrimaryButton(currentButton: $currentButton, totalButtons: self.buttons.count))
                .tag(i)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .tabViewStyle(PageTabViewStyle())
    }
}

struct ContentView: View {
    var body: some View {
        NavigationView {
            HomeView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
