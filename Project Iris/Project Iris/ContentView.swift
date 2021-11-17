//
//  ContentView.swift
//  Project Iris
//
//  Created by Connor Barker on 2021-10-24.
//

import SwiftUI

extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}

extension View {
    func cardStyle() -> some View {
        modifier(CardModifier())
    }
}

struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color("appBlack"))
            .font(Font.custom("Roboto-Black", size: 48))
            .clipShape(RoundedRectangle(cornerRadius: 5.0))
            .padding(.horizontal, 30)
            .padding(.vertical, 15)
            .multilineTextAlignment(.center)
    }
}

struct OnPressButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(configuration.isPressed ? Color("accentGrey") : Color("appBlack"))
    }
}

// TODO: you were making card buttons for the options/playback screens
struct CardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Font.custom("Roboto-Black", size: 48))
            .clipShape(RoundedRectangle(cornerRadius: 5.0))
            .padding(.horizontal, 30)
            .padding(.vertical, 15)
            .multilineTextAlignment(.center)
    }
}


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
            .buttonStyle(OnPressButtonStyle())
            .cardStyle()
    }
}

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

struct ChevronButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 20)
            .padding(.vertical, 30)
            .buttonStyle(OnPressButtonStyle())
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
                        nil :
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        if (home) {
                            NavigationLink(destination: SettingsView()) {
                                Image(systemName: "gearshape.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .imageScale(.large)
                                    .frame(width: 40, height: 40)
                                    .position(x: 40, y: 35)
                            }
                        } else {
                            Image(systemName: "chevron.left")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .imageScale(.small)
                                .frame(width: 20, height: 20)
                                .position(x: 35, y: 35)
                        }
                    }
                    .buttonStyle(OnPressButtonStyle())
                    
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

// A modifier that animates a font through various sizes.
struct AnimatableCustomFontModifier: AnimatableModifier {
    var name: String
    var size: CGFloat

    var animatableData: CGFloat {
        get { size }
        set { size = newValue }
    }

    func body(content: Content) -> some View {
        content
            .font(.custom(name, size: size))
    }
}

extension View {
    func animatableFont(name: String, size: CGFloat) -> some View {
        self.modifier(AnimatableCustomFontModifier(name: name, size: size))
    }
}

struct CardButton <Content : View> : View {
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
    private var play: Bool = false
    @State private var speed: Int = 1
    private var speedOptions: [String] = ["x0.5", "x1", "x1.5"]
    @State private var fontSizes: [CGFloat] = [32, 48, 32]
    
    var body: some View {
        AppThemeContainer(pageTitle: "playback", home: false) {
            VStack {
                Card(height: 200) {
                    HStack() {
                        ForEach(0..<speedOptions.count, id: \.self) { i in
                            Text(speedOptions[i])
                                .foregroundColor(speed == i ? Color("appBlack") : Color("accentGrey"))
                                .padding(.horizontal, 10)
                                .animatableFont(name: "Roboto-Black", size: fontSizes[i])
                                .onTapGesture {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8, blendDuration: 1)) {
                                        speed = i
                                        for j in 0..<fontSizes.count {
                                            fontSizes[j] = j == i ? 48 : 32
                                        }
                                    }
                                }
                        }
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .padding(.horizontal, 20)
                }
                
                Card(height: 200) {
                    Image(systemName: play ? "play.fill" : "pause.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                        .padding(.vertical, 60)
                }
                
                Card(height: 200) {
                    Image(systemName: "stop.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                        .padding(.vertical, 60)
                }
                
                Spacer()
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        }
    }
}

struct SettingsView: View {
    private var options: [String] = ["general", "playback", "font", "colour"]
    
    var body: some View {
        AppThemeContainer(pageTitle: "settings", home: false) {
            VStack {
                ForEach(0..<options.count, id: \.self) { i in
                    Card(height: 100) {
                        Text(options[i])
                    }
                }
                
                Spacer()
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
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
        .animation(.easeInOut)
        .transition(.slide)
    }
}

struct ContentView: View {
    var body: some View {
        NavigationView {
            HomeView()
        }
        .preferredColorScheme(.light)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
