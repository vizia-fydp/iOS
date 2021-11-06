//
//  ContentView.swift
//  Project Iris
//
//  Created by Connor Barker on 2021-10-24.
//

import SwiftUI

struct PrimaryButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                ZStack {
                    Color("appWhite")
                    HStack(spacing: 225) {
                        Image(systemName: "chevron.left")
                        Image(systemName: "chevron.right")
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
    var body: some View {
        AppThemeContainer(pageTitle: "home", home: true) {
            NavigationLink(destination: PlaybackView()) {
                Text("detect\ncolor")
            }
            .buttonStyle(PrimaryButton())
            
            Button {
                print("page 2")
            } label: {
                Text("2/3")
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
