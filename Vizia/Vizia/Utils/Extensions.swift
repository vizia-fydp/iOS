//
//  Extensions.swift
//  Project Iris
//
//  Created by Connor Barker on 2022-01-13.
//

import SwiftUI

extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}

extension View {
    func cardStyle() -> some View {
        modifier(CardModifier())
    }
    
    func animatableFont(name: String, size: CGFloat) -> some View {
        self.modifier(AnimatableCustomFontModifier(name: name, size: size))
    }
}

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
