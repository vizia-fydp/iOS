//
//  ImagePicker.swift
//  FYDP Test App
//
//  Created by Waleed Ahmed on 2021-05-28.
//
// Tutorials followed to figure out how to do this:
// * https://www.hackingwithswift.com/books/ios-swiftui/using-coordinators-to-manage-swiftui-view-controllers
// * https://www.youtube.com/watch?v=GRX5Dha_Clw

import SwiftUI

struct ImagePicker : UIViewControllerRepresentable {
    @Binding var image : UIImage?
    @Binding var imageChanged : Bool

    @Environment(\.presentationMode) var presentationMode;

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera;
//        picker.sourceType = .photoLibrary
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator : NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent : ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
                parent.imageChanged = true
            }
            parent.presentationMode.wrappedValue.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.imageChanged = false
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

