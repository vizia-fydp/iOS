//
//  Speech.swift
//  FYDP Test App
//
//  Created by Waleed Ahmed on 2021-10-17.
//  https://developer.apple.com/documentation/avfoundation/speech_synthesis

import AVFoundation

struct Speech {
    private let synthesizer = AVSpeechSynthesizer()
    var voice : AVSpeechSynthesisVoice?
    var rate : Float
    var pitchMultiplier : Float
    var postUtteranceDelay : TimeInterval
    var volume : Float

    init(language : String = "en-GB",
         rate : Float = 0.57,
         pitchMultiplier : Float = 0.8,
         postUtteranceDelay: TimeInterval = 0.2,
         volume: Float = 0.8) {
        self.voice = AVSpeechSynthesisVoice(language: language)
        self.rate = rate
        self.pitchMultiplier = pitchMultiplier
        self.postUtteranceDelay = postUtteranceDelay
        self.volume = volume
    }

    func speak(text : String) {
        let utterance = AVSpeechUtterance(string: text)

        // Configure the utterance
        utterance.rate = self.rate
        utterance.pitchMultiplier = self.pitchMultiplier
        utterance.postUtteranceDelay = self.postUtteranceDelay
        utterance.volume = self.volume
        utterance.voice = self.voice

        // Tell the synthesizer to speak the utterance
        self.synthesizer.speak(utterance)
    }
}
