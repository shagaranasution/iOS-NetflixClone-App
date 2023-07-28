//
//  NCTitlePreviewViewViewModel.swift
//  Netflix Clone
//
//  Created by Shagara F Nasution on 24/07/23.
//

import Foundation

final class NCTitlePreviewViewViewModel {
    
    private let title: NCTitle
    
    init(title: NCTitle) {
        self.title = title
    }
    
    private var didFetchTitlePreviewHandler: ((String, String, URL?) -> Void)?
    
    public func fetchTitlePreview() {
        guard let titleName = title.originalTitle ?? title.originalName else {
            return
        }
        let queryItems = [
            URLQueryItem(name: "q", value: "\(titleName) trailer"),
            URLQueryItem(name: "key", value: NCRequest.Constants.YOUTUBE_DATA_API_KEY),
        ]
        let endpointString = "\(NCRequest.Constants.youtubeAPIBaseURL)/search"
        let request = NCRequest(endpoint: .otherEndpoint(endpointString), queryParamaters: queryItems)
        NCService.shared.execute(
            request,
            expecting: NCYoutubeSearchResponse.self) { [weak self] result in
                switch result {
                case .success(let model):
                    let videoId = model.items[0].id.videoId
                    let videoPreviewURL = URL(string: "https://www.youtube.com/embed/\(videoId)")
                    let titleText = self?.title.originalTitle ?? self?.title.originalName ?? "Untitled"
                    let overviewText = self?.title.overview ?? ""
            
                    self?.didFetchTitlePreviewHandler?(titleText, overviewText, videoPreviewURL)
                case .failure(let error):
                    print(String(describing: error))
                }
            }
    }
    
    public func registerDidFetchTitlePreviewHandler(
        _ block: @escaping (String, String, URL?) -> Void
    ) {
        self.didFetchTitlePreviewHandler = block
    }
    
    public func downloadTitle(completion: ((Result<Void, Error>) -> Void)? = nil) {
        NCDataPersistenceManager.shared.downloadTitle(model: title) { result in
            switch result {
            case .success:
                NotificationCenter.default.post(name: Notification.Name("downloaded"), object: nil)
                completion?(.success(()))
            case .failure(let error):
                print(String(describing: error))
                completion?(.failure(error))
            }
        }
    }
    
}
