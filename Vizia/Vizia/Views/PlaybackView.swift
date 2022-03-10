//
//  PlaubackView.swift
//  Project Iris
//
//  Created by Connor Barker on 2022-01-13.
//

import SwiftUI

@available(iOS 15.0, *)
struct PlaybackView: View {
    @State private var isPlaying: Bool = true
    @State private var speed: Int = 1
    private var speedOptions: [String] = ["x0.5", "x1", "x1.5"]
    private var speedOptionsVoiceover: [String] = ["50% playback speed", "100% playback speed", "150% playback speed"]
    @State private var fontSizes: [CGFloat] = [32, 48, 32]
    @Binding var speech: Speech

    init(speech: Binding<Speech>) {
        self._speech = speech
    }

    var body: some View {
        AppThemeContainer(pageTitle: "playback", home: false) {
            VStack {
                Card(height: 175) {
                    HStack() {
                        ForEach(0..<speedOptions.count, id: \.self) { i in
                            // Speed control buttons
                            Text(speedOptions[i])
                                .foregroundColor(speed == i ? Color("appBlack") : Color("accentGrey"))
                                .padding(.horizontal, 10)
                                .animatableFont(name: "Roboto-Black", size: fontSizes[i])
                                .onTapGesture {
                                    // No way to change rate of speech in place, have to
                                    // restart the speech at the new rate
                                    switch speedOptions[i] {
                                    case "x0.5":
                                        self.speech.restart(rate: slowRate)
                                    case "x1":
                                        self.speech.restart(rate: mediumRate)
                                    case "x1.5":
                                        self.speech.restart(rate: fastRate)
                                    default:
                                        self.speech.restart()
                                    }
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8, blendDuration: 1)) {
                                        speed = i
                                        for j in 0..<fontSizes.count {
                                            fontSizes[j] = j == i ? 48 : 32
                                        }
                                    }
                                }
                                .accessibility(label: Text(speedOptionsVoiceover[i]))
                        }
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .padding(.horizontal, 20)
                    .accessibility(addTraits: [.startsMediaSession])
                }
                .accessibilitySortPriority(6)

                HStack {
                    // Play/Pause button
                    Button {
                        if (isPlaying) {
                            self.speech.pause()
                        } else {
                            self.speech.unpause()
                        }
                        isPlaying = !isPlaying
                    } label: {
                        Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                            .padding(.vertical, 45)
                    }
                    .buttonStyle(CardButtonStyle(height: 175, square: true))
                    .padding(.top, 15)
                    .padding(.leading, 30)
                    .padding(.trailing, 15)
                    .accessibilitySortPriority(7)
                    .accessibility(addTraits: [.startsMediaSession])

                    // Repeat button
                    Button {
                        self.isPlaying = true
                        self.speech.restart()
                    } label: {
                        Image(systemName: "repeat")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                            .padding(.vertical, 45)
                    }
                    .buttonStyle(CardButtonStyle(height: 175, square: true))
                    .padding(.top, 15)
                    .padding(.leading, 15)
                    .padding(.trailing, 30)
                    .accessibilitySortPriority(8)
                    .accessibility(label: Text("repeat"))
                    .accessibility(addTraits: [.startsMediaSession])
                }
                
                Spacer()
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        }
    }
}
