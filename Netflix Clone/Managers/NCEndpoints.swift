//
//  NCEndpoint.swift
//  Netflix Clone
//
//  Created by Shagara F Nasution on 16/07/23.
//

import Foundation

protocol NCEndpoint where Self: RawRepresentable, Self.RawValue == String {
    
    static var baseUrl: String { get }
    var url: String { get }
    var credentials: (key: String, value: String)? { get }
    
}

extension NCEndpoint {
    var url: String {
        return "\(Self.baseUrl)/\(rawValue)"
    }
    
    var credentials: (key: String, value: String)? {
        return nil
    }
}

enum NCEndpoints {
    
    enum TheMovieDB: String, NCEndpoint {
        static let baseUrl = "https://api.themoviedb.org/3"
        
        case trendingMovies = "trending/movie/day"
        case trendingTvs = "trending/tv/day"
        case popularMovies = "movie/popular"
        case upcomingMovies = "movie/upcoming"
        case topRatadMovies = "movie/top_rated"
        case discoverMovies = "discover/movie"
        case searchMovies = "search/movie"
        
        var credentials: (key: String, value: String)? {
            guard let value = Bundle.main.infoDictionary?["API_KEY"] as? String else {
                return nil
            }
            return (key: "api_key", value: value)
        }
    }
    
    enum YouTubeData: String, NCEndpoint {
        static let baseUrl = "https://youtube.googleapis.com/youtube/v3"
        
        case search = "search"
        
        var credentials: (key: String, value: String)? {
            guard let value = Bundle.main.infoDictionary?["YOUTUBE_DATA_API_KEY"] as? String else {
                return nil
            }
            return (key: "key", value: value)
        }
    }
    
}
