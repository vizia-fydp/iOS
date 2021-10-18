//
//  ContentView.swift
//  FYDP Test App
//
//  Created by Waleed Ahmed on 2021-05-28.
//

import SwiftUI
import AVFoundation
import SwiftyTesseract
import SocketIO

//MARK: - ContentView
struct ContentView: View {
    @State private var showImagePicker = false
    @State private var image: Image?
    @State private var inputImage: UIImage?
    private var speech = Speech()
//    private var socketManager = SocketManager(socketURL: URL(string: "http://127.0.0.1:5000")!, config: [.log(true), .compress])
    private var socketManager = SocketManager(socketURL: URL(string: "https://33b0-2601-646-c200-cb40-c119-df75-41e7-9bac.ngrok.io")!, config: [.log(true), .compress])

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

            // Socket IO setup
            let socket = socketManager.defaultSocket

            socket.on(clientEvent: .connect) {data, ack in
                print("socket connected")
            }

            socket.on("test") {data, ack in
                guard let msg = data[0] as? String else { return }
                print(msg)
                speech.speak(text: msg)
            }

            socket.connect()
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
            speech.speak(text: result)
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
