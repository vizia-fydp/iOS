//
//  HomeView.swift
//  Project Iris
//
//  Created by Connor Barker on 2022-01-13.
//

import SwiftUI
import AVFoundation
import Alamofire

struct HomeView: View {
    @State private var showImagePicker = false
    @State private var inputImage: UIImage?
    @State private var currentButton: Int = 1

    private var speech = Speech()
    private var serverUrl = "https://9659-65-92-74-233.ngrok.io"

    private var actionButtons: [Int:String] = [
        1:"scan\ntext",
        2:"detect\nbill",
        3:"detect\ncolor"
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
        .sheet(isPresented: $showImagePicker, onDismiss: processImage) {
            ImagePicker(image: $inputImage)
        }
    }

    private func processImage() {
//        guard let scaledImage = inputImage?.scaledImage(1000) else { return }
        colorDetection()
    }

    private func colorDetection() {
        guard let scaledImage = inputImage?.scaledImage(1000) else { return }
        print(scaledImage)
        let headers: HTTPHeaders = [.contentType("image/jpeg")]
        guard let imageData = scaledImage.jpegData(compressionQuality: 0.50) else { return }
//        AF.upload(imageData, to: "\(serverUrl)/detect_color", headers: headers).responseDecodable(of: ColorDetectionResponse.self) { response in
        AF.upload(imageData, to: "\(serverUrl)/detect_color", headers: headers).responseJSON { response in
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
                    print("Something went wrong")
                    print(error)
            }
        }
    }
}
