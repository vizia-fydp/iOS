//
//  SheetViewController.swift
//  Project Iris
//
//  Created by Connor Barker on 2022-01-13.
//
// credit @azamsharp on github (https://gist.github.com/azamsharp/120abcd639fd773132b94de77ba1fa3b)


import SwiftUI

enum SheetMode {
    case none
    case quarter
    case half
    case full
}

struct FlexibleSheetContainer<Content: View>: View {
    
    let content: () -> Content
    var sheetMode: Binding<SheetMode>
    
    init(sheetMode: Binding<SheetMode>, @ViewBuilder content: @escaping () -> Content) {
        
        self.content = content
        self.sheetMode = sheetMode
        
    }
    
    private func calculateOffset() -> CGFloat {
        switch sheetMode.wrappedValue {
            case .none:
                return UIScreen.main.bounds.height
            case .quarter:
                return UIScreen.main.bounds.height - 200
            case .half:
                return UIScreen.main.bounds.height/2
            case .full:
                return 0
        }
    }
    
    var body: some View {
        content()
            .offset(y: calculateOffset())
            .animation(.spring())
            .edgesIgnoringSafeArea(.all)
    }
}
