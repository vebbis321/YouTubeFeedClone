//
//  NewsError.swift
//  NewsApp
//
//  Created by Vebjørn Daniloff on 9/28/23.
//

import Foundation

enum YouTubeCloneError: Error, LocalizedError {
    case `default`(_ error: Error)
    case defaultCustom(_ string: String)
    case somethingWentWrong
    case invalidUrl
    case invalidResponse(code: Int)
    case invalidData(Error)

    var errorDescription: String? {
        switch self {
        case let .default(err):
            return err.localizedDescription

        case .somethingWentWrong:
            return NSLocalizedString("Something went wrong.", comment: "")

        case let .defaultCustom(customErrorString):
            return NSLocalizedString(customErrorString, comment: "")

        case .invalidUrl:
            return "Invalid URL"

        case .invalidResponse(code: let code):
            return "Failed with status code: \(code)"

        case .invalidData(let err):
            return "Invalid data: \(err)"
        }
    }
}
