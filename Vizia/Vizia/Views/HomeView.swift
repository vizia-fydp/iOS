//
//  HomeView.swift
//  Project Iris
//
//  Created by Connor Barker on 2022-01-13.
//

import SwiftUI
import AVFoundation
import Alamofire
import UIKit

@available(iOS 15.0, *)
struct HomeView: View {
    @State private var showPlaybackView: Bool = false
    @State private var showImagePicker = false
    @State private var inputImage: UIImage?
    @State private var currentButton: Int = 1

    private var speech = Speech()
    private var serverUrl = "https://0b50-64-229-183-215.ngrok.io"

    private var actionButtons: [Int:String] = [
        1:"scan\ntext",
        2:"detect\ncolor",
        3:"detect\nbill"
    ]
    
    var body: some View {
        AppThemeContainer(pageTitle: "home", home: true) {
            ButtonCarouselView(buttons: actionButtons, currentButton: $currentButton, showImagePicker: $showImagePicker)

            Button {
                currentButton = currentButton == actionButtons.count ? 1 : currentButton + 1
            } label: {
                Text("\($currentButton.wrappedValue)/\(actionButtons.count)")
            }
            .buttonStyle(PageButton())
            .accessibilityHidden(true)
        }
        .onAppear {
            // Configure audio to play in background
            try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
        }
        .sheet(isPresented: $showPlaybackView) {
            HalfSheet {
                PlaybackView()
            }
            .edgesIgnoringSafeArea(.bottom)
        }
        .sheet(isPresented: $showImagePicker, onDismiss: processImage) {
            ImagePicker(image: $inputImage)
        }
    }

    private func processImage() {
        showPlaybackView = true
        switch currentButton {
        case 1:
//            print("Performing OCR...")
            ocr()
        case 2:
//            print("Performing color detection...")
            colorDetection()
        default:
            print("Not implemented")
        }
    }

    private func ocr() {
        guard let scaledImage = inputImage?.scaledImage(1000) else { return }
        let headers: HTTPHeaders = [.contentType("image/jpeg")]
        guard let imageData = scaledImage.jpegData(compressionQuality: 0.50)?.base64EncodedString() else { return }
        AF.upload(Data(imageData.utf8), to: "\(serverUrl)/ocr", headers: headers).responseDecodable(of: OcrResponse.self) { response in
            switch response.result {
                case .success:
                    print(response.result)
                    if let data = response.data {
                        do {
                            let decoded = try JSONDecoder().decode(OcrResponse.self, from: data)
                            speech.speak(text: decoded.text)
                        } catch {
                            print("Error decoding JSON response for OCR")
                        }
                    }
                case .failure(let error):
                    print(error)
            }
        }
    }

    private func colorDetection() {
        guard let scaledImage = inputImage?.scaledImage(1000) else { return }
        let headers: HTTPHeaders = [.contentType("image/jpeg")]
        guard let imageData = scaledImage.jpegData(compressionQuality: 0.50) else { return }
        AF.upload(imageData, to: "\(serverUrl)/detect_color", headers: headers).responseDecodable(of: ColorDetectionResponse.self) { response in
            switch response.result {
                case .success:
                    print(response.result)

                    if let data = response.data {
                        do {
                            let decoded = try JSONDecoder().decode(ColorDetectionResponse.self, from: data)
                            speech.speak(text: decoded.colors)
                        } catch {
                            print("Error decoding JSON response for Color Detection")
                        }
                    }
                case .failure(let error):
                    print(error)
            }
        }
    }
}
