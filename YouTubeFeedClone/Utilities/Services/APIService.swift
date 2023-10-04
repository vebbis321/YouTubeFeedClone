//
//  APIService.swift
//  YouTubeFeedClone
//
//  Created by Vebjorn Daniloff on 10/4/23.
//

import Foundation

protocol APIServiceProtocol {
    func findVideos(page: Int) async throws -> [Video]
}


final class APIService: APIServiceProtocol {
    private let endPoint = "https://api.pexels.com/videos/popular?"

    func findVideos(page: Int) async throws -> [Video] {

        guard let url = URL(string: endPoint + "&page=\(page)") else {
            throw YouTubeCloneError.invalidUrl
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("API KEY", forHTTPHeaderField: "Authorization")

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let response = response as? HTTPURLResponse else {
            throw YouTubeCloneError.somethingWentWrong
        }

        guard response.statusCode == 200 else {
            throw YouTubeCloneError.invalidResponse(code: response.statusCode)
        }

        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let response = try decoder.decode(ResponseBody.self, from: data)
            return response.videos
        } catch {
            throw YouTubeCloneError.invalidData(error)
        }
    }
}
