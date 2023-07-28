//
//  NCEndpoint.swift
//  Netflix Clone
//
//  Created by Shagara F Nasution on 16/07/23.
//

import Foundation

enum NCEndpoint {
    case trendingMovies
    case trendingTvs
    case popularMovies
    case upcomingMovies
    case topRatadMovies
    case discoverMovies
    case searchMovies
    case otherEndpoint(String)
    
    public var path: String {
        switch self {
        case .trendingMovies:
            return "trending/movie/day"
        case .trendingTvs:
            return "trending/tv/day"
        case .popularMovies:
            return "movie/popular"
        case .upcomingMovies:
            return "movie/upcoming"
        case .topRatadMovies:
            return "movie/top_rated"
        case .discoverMovies:
            return "discover/movie"
        case .searchMovies:
            return "search/movie"
        case .otherEndpoint(let string):
            return string
        }
    }
}
