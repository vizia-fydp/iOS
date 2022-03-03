//
//  HomeView.swift
//  Project Iris
//
//  Created by Connor Barker on 2022-01-13.
//

import SwiftUI
import AVFoundation
import SocketIO
import Alamofire
import UIKit

@available(iOS 15.0, *)
struct HomeView: View {
    @State private var showPlaybackView: Bool = false
    @State private var showImagePicker = false
    @State private var inputImage: UIImage?
    @State private var currentButton: Int = 1
    @State private var socketManager : SocketManager?
    @State private var speech = Speech()

    private let serverUrl = "https://98dd-2620-101-f000-700-0-972a-bfd8-48e8.ngrok.io"

    private var actionButtons: [Int:String] = [
        1:"scan\ntext",
        2:"scan\ndocument",
        3:"detect\ncolor",
        4:"detect\nbill"
    ]

    var body: some View {
        AppThemeContainer(pageTitle: "home", home: true) {
            ButtonCarouselView(buttons: actionButtons, currentButton: $currentButton, showImagePicker: $showImagePicker, speech: $speech)

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

            // SocketIO setup
            socketManager = SocketManager(socketURL: URL(string: serverUrl)!, config: [.log(false), .compress])
            let socket = socketManager!.defaultSocket
            socket.on(clientEvent: .connect) {data, ack in
                print("socket connected")
            }
            socket.on("iOS_info") {data, ack in
                // Parse data sent on socket
                guard let data = data[0] as? [String: String] else { return }
                guard let text = data["text"] else { return }
                let language = data["language"] ?? "en"

                // Speak text without playback controls
                speech.speak(text: text, rate: mediumRate, language: language)
            }
            socket.on("iOS_results") {data, ack in
                // Parse data sent on socket
                guard let data = data[0] as? [String: String] else { return }
                guard let text = data["text"] else { return }
                let language = data["language"] ?? "en"

                // Speak text with playback controls
                showPlaybackView = true
                speech.speak(text: text, rate: mediumRate, language: language)
            }
            socket.connect()
        }
        .sheet(isPresented: $showPlaybackView, onDismiss: { speech.stop() }) {
            HalfSheet {
                PlaybackView(speech: $speech)
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
            ocr(type: "TEXT_DETECTION")
        case 2:
            ocr(type: "DOCUMENT_TEXT_DETECTION")
        case 3:
            colorDetection(k: 3)
        case 4:
            moneyClassification()
        default:
            print("Not implemented")
        }
    }

    // type : Either "TEXT_DETECTION" or "DOCUMENT_TEXT_DETECTION"
    private func ocr(type: String) {
        // Prepare image for request (scale + compress)
        guard let scaledImage = inputImage?.scaledImage(1000) else { return }
        guard let imageData = scaledImage.jpegData(compressionQuality: 0.50)?.base64EncodedString() else { return }

        let headers: HTTPHeaders = [.contentType("image/jpeg")]

        AF.upload(Data(imageData.utf8), to: "\(serverUrl)/ocr?type=\(type)", headers: headers).responseDecodable(of: OcrResponse.self) { response in
            switch response.result {
                case .success:
                    print(response.result)
                    if let data = response.data {
                        do {
                            let decoded = try JSONDecoder().decode(OcrResponse.self, from: data)
                            speech.speak(text: decoded.text, rate: mediumRate, language: decoded.language)
                        } catch {
                            print("Error decoding JSON response for OCR")
                        }
                    }
                case .failure(let error):
                    print(error)
            }
        }
    }

    // k : How many colors to return
    private func colorDetection(k: Int) {
        // Prepare image for request (scale + compress)
        guard let scaledImage = inputImage?.scaledImage(1000) else { return }
        guard let imageData = scaledImage.jpegData(compressionQuality: 0.50) else { return }

        let headers: HTTPHeaders = [.contentType("image/jpeg")]

        AF.upload(imageData, to: "\(serverUrl)/detect_color?k=\(k)", headers: headers).responseDecodable(of: ColorDetectionResponse.self) { response in
            switch response.result {
                case .success:
                    print(response.result)

                    if let data = response.data {
                        do {
                            let decoded = try JSONDecoder().decode(ColorDetectionResponse.self, from: data)
                            speech.speak(text: decoded.colors, rate: mediumRate, language: "en")
                        } catch {
                            print("Error decoding JSON response for Color Detection")
                        }
                    }
                case .failure(let error):
                    print(error)
            }
        }
    }

    private func moneyClassification() {
        // Prepare image for request (scale + compress)
        guard let scaledImage = inputImage?.scaledImage(1000) else { return }
        guard let imageData = scaledImage.jpegData(compressionQuality: 0.50) else { return }

        let headers: HTTPHeaders = [.contentType("image/jpeg")]

        AF.upload(imageData, to: "\(serverUrl)/classify_money", headers: headers).responseDecodable(of: MoneyClassificationResponse.self) { response in
            switch response.result {
                case .success:
                    print(response.result)

                    if let data = response.data {
                        do {
                            let decoded = try JSONDecoder().decode(MoneyClassificationResponse.self, from: data)
                            let txt = decoded.predicted_class == "no_bill" ? "No bill detected" : decoded.predicted_class
                            speech.speak(text: txt, rate: mediumRate, language: "en")
                        } catch {
                            print("Error decoding JSON response for Money Classification")
                        }
                    }
                case .failure(let error):
                    print(error)
            }
        }
    }
}
