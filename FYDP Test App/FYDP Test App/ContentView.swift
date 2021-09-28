//
//  ContentView.swift
//  FYDP Test App
//
//  Created by Waleed Ahmed on 2021-05-28.
//

import SwiftUI
import AVFoundation
import SwiftyTesseract

//MARK: - ContentView
struct ContentView: View {
    @State private var showImagePicker = false
    @State private var image: Image?
    @State private var inputImage: UIImage?

    var body: some View {
        NavigationView {
            VStack {
                image?.resizable().scaledToFit()
            }
            .navigationBarItems(trailing: imagePick)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("FYDP")
        }
        .onAppear {
            // Configure audio to play in background
            try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
        }
    }

    private var imagePick: some View {
        Button(action: {
            self.showImagePicker = true
        }) {
            Image(systemName: "camera").imageScale(.large)
        }
        .sheet(isPresented: $showImagePicker, onDismiss: loadImage) {
            ImagePicker(image: $inputImage)
        }
    }

    private func loadImage() {
//        guard let inputImage = inputImage else { return }
//        guard let inputImage = inputImage?.scaledImage(1000) else { return }
        guard let inputImage = inputImage?.scaledImage(1000)?.grayscale() else { return }
//        guard let inputImage = inputImage?.scaledImage(1000)?.grayscale()?.otsuThreshold() else { return }

        image = Image(uiImage: inputImage)

        // perform OCR using Tesseract
        let tesseract = Tesseract(language: .english)

        let result = tesseract.performOCR(on: inputImage)
        switch result {
        case .success(let result):
            print(result)

            // Text to Speech using AVFoundation
            // https://developer.apple.com/documentation/avfoundation/speech_synthesis
            let utterance = AVSpeechUtterance(string: result)

            // Configure the utterance.
            utterance.rate = 0.57
            utterance.pitchMultiplier = 0.8
            utterance.postUtteranceDelay = 0.2
            utterance.volume = 0.8

            // Retrieve the British English voice.
            let voice = AVSpeechSynthesisVoice(language: "en-GB")
            utterance.voice = voice

            // Create a speech synthesizer.
            let synthesizer = AVSpeechSynthesizer()

            // Tell the synthesizer to speak the utterance.
            synthesizer.speak(utterance)
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}

//MARK: - UIImage extensions
extension UIImage {
    // https://nshipster.com/image-resizing/#technique-1-drawing-to-a-uigraphicsimagerenderer
    // https://www.raywenderlich.com/2010498-tesseract-ocr-tutorial-for-ios#toc-anchor-010
    func scaledImage(_ maxDimension: CGFloat) -> UIImage? {
        var scaledSize = CGSize(width: maxDimension, height: maxDimension)

        if size.width > size.height {
          scaledSize.height = size.height / size.width * scaledSize.width
        } else {
          scaledSize.width = size.width / size.height * scaledSize.height
        }

        // Resize using Core Graphics
        UIGraphicsBeginImageContext(scaledSize)
        draw(in: CGRect(origin: .zero, size: scaledSize))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage
    }

    // https://prograils.com/grayscale-conversion-swift
    func grayscale() -> UIImage? {
        let context = CIContext(options: nil)
        if let filter = CIFilter(name: "CIPhotoEffectNoir") {
            filter.setValue(CIImage(image: self), forKey: kCIInputImageKey)
            if let output = filter.outputImage {
                if let cgImage = context.createCGImage(output, from: output.extent) {
                    return UIImage(cgImage: cgImage)
                }
            }
        }
        return nil
    }

    func otsuThreshold() -> UIImage? {
        let context = CIContext(options: nil)
        if let filter = CIFilter(name: "CIColorThresholdOtsu") {
            filter.setValue(CIImage(image: self), forKey: kCIInputImageKey)
            if let output = filter.outputImage {
                if let cgImage = context.createCGImage(output, from: output.extent) {
                    return UIImage(cgImage: cgImage)
                }
            }
        }
        return nil
    }
}


//MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
