//
//  ContentView.swift
//  FYDP Test App
//
//  Created by Waleed Ahmed on 2021-05-28.
//

import SwiftUI
import SwiftyTesseract

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
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)

        // perform OCR using Tesseract
        let tesseract = Tesseract(language: .english)
        let result = tesseract.performOCR(on: inputImage)
        switch result {
        case .success(let string):
            print(string)
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
