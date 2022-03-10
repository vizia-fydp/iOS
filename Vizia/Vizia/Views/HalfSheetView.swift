//
//  HalfSheetView.swift
//  Project Iris
//
//  Created by Connor Barker on 2022-01-25.
//

import UIKit
import SwiftUI

@available(iOS 15.0, *)
struct HalfSheet<Content>: UIViewControllerRepresentable where Content : View {
    private let content: Content

    @inlinable init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    func makeUIViewController(context: Context) -> HalfSheetController<Content> {
        return HalfSheetController(rootView: content)
    }

    func updateUIViewController(_: HalfSheetController<Content>, context: Context) {

    }
}
