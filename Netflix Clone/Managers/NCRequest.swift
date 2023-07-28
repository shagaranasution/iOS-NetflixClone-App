//
//  NCRequest.swift
//  Netflix Clone
//
//  Created by Shagara F Nasution on 16/07/23.
//

import Foundation

final class NCRequest {
    struct Constants {
        static let API_KEY = Bundle.main.infoDictionary?["API_KEY"] as? String
        static let YOUTUBE_DATA_API_KEY = Bundle.main.infoDictionary?["YOUTUBE_DATA_API_KEY"] as? String
        static let baseURL = "https://api.themoviedb.org/3"
        static let youtubeAPIBaseURL = "https://youtube.googleapis.com/youtube/v3"
    }
    
    public let endpoint: NCEndpoint
    
    private let queryParamaters: [URLQueryItem]
    
    private var urlString: String {
        var string = ""
        switch endpoint {
        case .trendingMovies, .trendingTvs, .popularMovies, .upcomingMovies, .topRatadMovies, .discoverMovies, .searchMovies:
            string += Constants.baseURL
            string += "/"
            string += endpoint.path
        case .otherEndpoint(let urlString):
            string += urlString
        }
       
        if !queryParamaters.isEmpty {
            string += "?"
            let argumentString = queryParamaters.compactMap { item in
                guard let value = item.value?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                    return nil
                }
                return "\(item.name)=\(value)"
            }.joined(separator: "&")
            string += argumentString
        }
        
        return string
    }
    
    public lazy var url = URL(string: urlString)
    
    public let httpMethod = "GET"
    
    // MARK: Initialization
    
    public init(
        endpoint: NCEndpoint,
        queryParamaters: [URLQueryItem] = []
    ) {
        self.endpoint = endpoint
        self.queryParamaters = queryParamaters
    }
}

extension NCRequest {
    static let listTrendingMoviesRequest = NCRequest(
        endpoint: .trendingMovies,
        queryParamaters: [URLQueryItem(name: "api_key", value: Constants.API_KEY)]
    )
    static let listTrendingTvsRequest = NCRequest(
        endpoint: .trendingTvs,
        queryParamaters: [URLQueryItem(name: "api_key", value: Constants.API_KEY)]
    )
    static let listTrendingPopularMoviesRequest = NCRequest(
        endpoint: .popularMovies,
        queryParamaters: [URLQueryItem(name: "api_key", value: Constants.API_KEY)]
    )
    static let listTrendingTopRatedMoviesRequest = NCRequest(
        endpoint: .topRatadMovies,
        queryParamaters: [URLQueryItem(name: "api_key", value: Constants.API_KEY)]
    )
    static let listTrendingUpcomingMoviesRequest = NCRequest(
        endpoint: .upcomingMovies,
        queryParamaters: [URLQueryItem(name: "api_key", value: Constants.API_KEY)]
    )
    static let listDiscoverMoviesRequest = NCRequest(
        endpoint: .discoverMovies,
        queryParamaters: [URLQueryItem(name: "api_key", value: Constants.API_KEY)]
    )
}
