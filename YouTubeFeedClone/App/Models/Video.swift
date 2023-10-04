//
//  Video.swift
//  YouTubeClone
//
//  Created by Vebjørn Daniloff on 9/27/23.
//

import Foundation

struct Video: Identifiable, Hashable, Codable {
    var id: Int
    var image: String
    var width: Int
    var height: Int
    var duration: Int
    var user: User
    var videoFiles: [VideoFile]

    struct User: Identifiable, Codable, Hashable {
        var id: Int
        var name: String
        var url: String
    }

    struct VideoFile: Identifiable, Codable, Hashable {
        var id: Int
        var quality: String
        var fileType: String
        var link: String
    }
}
