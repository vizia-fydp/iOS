//
//  Http.swift
//  FYDP Test App
//
//  Created by Waleed Ahmed on 2021-11-03.
//
// https://stackoverflow.com/questions/40519829/upload-image-to-server-using-alamofire
// https://stackoverflow.com/questions/11251340/convert-between-uiimage-and-base64-string
// https://codewithchris.com/alamofire/

import Foundation

struct ColorDetectionResponse : Codable {
    let color_name : String
    let rgb : [Float]
}
