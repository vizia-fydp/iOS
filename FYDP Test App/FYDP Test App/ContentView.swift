//
//  ContentView.swift
//  FYDP Test App
//
//  Created by Waleed Ahmed on 2021-05-28.
//

import SwiftUI

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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
