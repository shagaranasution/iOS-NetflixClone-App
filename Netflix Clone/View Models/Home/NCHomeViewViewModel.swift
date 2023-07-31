//
//  NCHomeViewViewModel.swift
//  Netflix Clone
//
//  Created by Shagara F Nasution on 17/07/23.
//

import Foundation

final class NCHomeViewViewModel {
    
    enum Section: CaseIterable {
        case trendingMovies
        case trendingTvs
        case popular
        case upcoming
        case topRated
        
        public var sectionTitle: String {
            switch self {
            case .trendingMovies:
                return "Trending movies"
            case .trendingTvs:
                return "Trending Tv"
            case .popular:
                return "Popular"
            case .upcoming:
                return "Upcoming"
            case .topRated:
                return "Top rated"
            }
        }
    }
    
    public let sections: [Section] = Section.allCases
    
    private var didFetchTrendingTitle: ((NCTitle) -> Void)?
    
    init() {}
    
    public func fetchTrendingMovies() {
        NCService.shared.execute(
            .listTrendingMoviesRequest,
            expecting: NCTGetListTitlesResponse.self) { [weak self] result in
                switch result {
                case .success(let model):
                    guard let title = model.results.randomElement() else {
                        return
                    }
                    self?.didFetchTrendingTitle?(title)
                case .failure(let error):
                    print(String(describing: error))
                }
            }
    }
    
    public func registerDidFetchPosterPathHandler(
        _ block: @escaping (NCTitle) -> Void
    ) {
        didFetchTrendingTitle = block
    }
    
}
