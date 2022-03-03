//
//  Speech.swift
//  FYDP Test App
//
//  Created by Waleed Ahmed on 2021-10-17.
//  https://developer.apple.com/documentation/avfoundation/speech_synthesis

import AVFoundation

let slowRate : Float = 0.47
let mediumRate : Float = 0.57
let fastRate : Float = 0.67

struct Speech {
    // Synthesizer config
    private let synthesizer = AVSpeechSynthesizer()
    var voice : AVSpeechSynthesisVoice?
    var rate : Float
    var pitchMultiplier : Float
    var postUtteranceDelay : TimeInterval
    var volume : Float

    // Most recent text, used for replaying
    var text: String?

    init(language : String = "en",
         rate : Float = mediumRate,
         pitchMultiplier : Float = 0.8,
         postUtteranceDelay: TimeInterval = 0.2,
         volume: Float = 0.8) {
        self.voice = AVSpeechSynthesisVoice(language: language)
        self.rate = rate
        self.pitchMultiplier = pitchMultiplier
        self.postUtteranceDelay = postUtteranceDelay
        self.volume = volume
    }

    mutating func speak(text : String, rate : Float? = nil, language : String? = nil) {
        // Remember this text in case we need to replay it
        self.text = text

        // Remember new rate if one is specified
        if let rate = rate {
            self.rate = rate
        }

        // Update language if one is specified
        if let language = language {
            self.voice = AVSpeechSynthesisVoice(language: language)
        }

        // Configure the utterance
        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = self.rate
        utterance.pitchMultiplier = self.pitchMultiplier
        utterance.postUtteranceDelay = self.postUtteranceDelay
        utterance.volume = self.volume
        utterance.voice = self.voice

        // Halt current speech incase there is something playing
        self.stop()

        // Tell the synthesizer to speak the utterance
        self.synthesizer.speak(utterance)
    }

    func pause() {
        self.synthesizer.pauseSpeaking(at: .immediate)
    }

    func unpause() {
        self.synthesizer.continueSpeaking()
    }

    mutating func restart(rate : Float? = nil) {
        guard let text = self.text else { return }
        self.speak(text: text, rate: rate)
    }

    func stop() {
        self.synthesizer.stopSpeaking(at: .immediate)
    }
}

