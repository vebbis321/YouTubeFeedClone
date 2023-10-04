//
//  ResponseBody.swift
//  YouTubeClone
//
//  Created by Vebjørn Daniloff on 9/27/23.
//

import Foundation

struct ResponseBody: Codable {
    var page: Int
    var perPage: Int
    var totalResults: Int
    var url: String
    var videos: [Video]
}
