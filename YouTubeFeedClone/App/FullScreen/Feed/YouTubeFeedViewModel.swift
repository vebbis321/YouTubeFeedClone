//
//  YouTubeFeedViewModel.swift
//  YouTubeFeedClone
//
//  Created by Vebjorn Daniloff on 10/4/23.
//

import Foundation
import Combine

final class YouTubeFeedViewModel {

    enum State {
        case loading
        case loaded(feed: [Video], shorts: [Video])
        case error(Error)
    }

    var state = CurrentValueSubject<State, Never>(.loading)

    private let service: APIServiceProtocol

    init(service: APIServiceProtocol) {
        self.service = service
        loadFeed()
    }

    func loadFeed() {
        Task {
            do {
                let allVideos = try await service.findVideos(page: 1)
                let shorts = allVideos.filter { $0.width == 1920 && $0.height == 1080 }
                let videos = allVideos.filter({ !shorts.contains($0) })
                
                state.send(.loaded(feed: videos, shorts: shorts))
            } catch {
                state.send(.error(error))
            }
        }
    }


}
