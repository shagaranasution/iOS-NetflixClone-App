//
//  NCHeroHeaderViewViewModel.swift
//  Netflix Clone
//
//  Created by Shagara F Nasution on 25/07/23.
//

import Foundation

final class NCHeroHeaderViewViewModel {
    
    private var didFetchPosterPathHandler: ((String) -> Void)?

    init() {}
    
    public func fetchTrendingMovies() {
        NCService.shared.execute(
            .listTrendingMoviesRequest,
            expecting: NCTGetListTitlesResponse.self) { [weak self] result in
                switch result {
                case .success(let model):
                    let movie = model.results.randomElement()
                    let posterPath = "https://image.tmdb.org/t/p/w500\(movie?.posterPath ?? "")"
                    self?.didFetchPosterPathHandler?(posterPath)
                case .failure(let error):
                    print(String(describing: error))
                }
            }
    }
    
    public func registerDidFetchPosterPathHandler(
        _ block: @escaping (String) -> Void
    ) {
        didFetchPosterPathHandler = block
    }
    
}
