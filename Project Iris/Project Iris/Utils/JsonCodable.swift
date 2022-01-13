//
//  JsonCodable.swift
//  Project Iris
//
//  Created by Waleed Ahmed on 2022-01-13.
//

import Foundation

struct ColorDetectionResponse : Codable {
    let colors : String
    let rgb : [[Float]]
}
