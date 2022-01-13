//
//  PlaubackView.swift
//  Project Iris
//
//  Created by Connor Barker on 2022-01-13.
//

import SwiftUI

struct PlaybackView: View {
    @State private var play: Bool = false
    @State private var speed: Int = 1
    private var speedOptions: [String] = ["x0.5", "x1", "x1.5"]
    @State private var fontSizes: [CGFloat] = [32, 48, 32]
    
    var body: some View {
        AppThemeContainer(pageTitle: "playback", home: false) {
            if #available(iOS 15.0, *) {
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
                    .accessibilityChildren {
                        List {
                            NavigationLink(destination: PlaybackView()) {
                                Text("50%")
                            }
                            NavigationLink(destination: PlaybackView()) {
                                Text("100%")
                            }
                            NavigationLink(destination: PlaybackView()) {
                                Text("150%")
                            }
                        }
                        .accessibilityLabel(Text("playback speeds; currently 100%"))
                    }
                    .accessibilitySortPriority(6)
                
                    Button {
                        play = !play
                    } label: {
                        Image(systemName: play ? "play.fill" : "pause.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                            .padding(.vertical, 45)
                    }
                    .buttonStyle(CardButtonStyle(height: 200))
                    .accessibilitySortPriority(7)
                    
                    Button {
                        print("stop")
                    } label: {
                        Image(systemName: "stop.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                            .padding(.vertical, 45)
                    }
                    .buttonStyle(CardButtonStyle(height: 200))
                    .accessibilitySortPriority(8)
                    
                    Spacer()
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
//                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16.0))
            } else {
                Text("loser")
            }
        }
    }
}
