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
    
    init() {}
    
}
