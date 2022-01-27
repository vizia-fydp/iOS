//
//  HalfSheetController.swift
//  Project Iris
//
//  Created by Connor Barker on 2022-01-25.
//

import UIKit
import SwiftUI

@available(iOS 15.0, *)
class HalfSheetController<Content>: UIHostingController<Content> where Content : View {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let presentation = sheetPresentationController {
            presentation.detents = [.medium()]
        }
    }
}
