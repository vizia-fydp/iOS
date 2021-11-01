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
            .background(Color("appWhite"))
            .foregroundColor(.black)
            .font(Font.custom("Roboto-Black", size: 48))
            .clipShape(RoundedRectangle(cornerRadius: 5.0))
            .padding(.horizontal, 30)
            .padding(.vertical, 15)
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

struct ContentView: View {
    init() {
        UINavigationBar.appearance().backgroundColor = UIColor(Color("appWhite"))
    }
    var body: some View {
        NavigationView {
            ZStack {
                Color("appWhite")
                    .edgesIgnoringSafeArea(.top)
                Color("appBlack")
                    .edgesIgnoringSafeArea(.bottom)
                VStack {
                    ZStack {
                        Color("appWhite")
                            .edgesIgnoringSafeArea(.top)
                        Image(systemName: "line.3.horizontal")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .position(x: 45, y: 30)
                        Text("home")
                            .foregroundColor(Color("appBlack"))
                            .font(Font.custom("Roboto-Black", size: 36))
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 70)
                    .padding(.bottom, 15)
                    Button {
                        print("detecting")
                    } label: {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("detect colour")
                                .frame(maxWidth: 200)
                                .multilineTextAlignment(.center)
                                .font(Font.custom("Roboto-Black", size: 48))
                            Image(systemName: "chevron.right")
                        }
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
            .navigationBarHidden(true)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
