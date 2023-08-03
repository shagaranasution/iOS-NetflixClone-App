//
//  NCRequest.swift
//  Netflix Clone
//
//  Created by Shagara F Nasution on 16/07/23.
//

import Foundation

final class NCRequest {
    public let endpoint: any NCEndpoint
    
    private var queryParamaters: [URLQueryItem]
    
    private var urlString: String {
        var string = ""
        string += endpoint.url

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
        endpoint: any NCEndpoint,
        queryParamaters: [URLQueryItem] = []
    ) {
        self.endpoint = endpoint
        self.queryParamaters = queryParamaters
        
        if let credentials = endpoint.credentials {
            self.queryParamaters.append(URLQueryItem(name: credentials.key, value: credentials.value))
        }
    }
}

extension NCRequest {
    static let listTrendingMoviesRequest = NCRequest(
        endpoint: NCEndpoints.TheMovieDB.trendingMovies
    )
    static let listTrendingTvsRequest = NCRequest(
        endpoint: NCEndpoints.TheMovieDB.trendingTvs
    )
    static let listTrendingPopularMoviesRequest = NCRequest(
        endpoint: NCEndpoints.TheMovieDB.popularMovies
    )
    static let listTrendingTopRatedMoviesRequest = NCRequest(
        endpoint: NCEndpoints.TheMovieDB.topRatadMovies
    )
    static let listTrendingUpcomingMoviesRequest = NCRequest(
        endpoint: NCEndpoints.TheMovieDB.upcomingMovies
    )
    static let listDiscoverMoviesRequest = NCRequest(
        endpoint: NCEndpoints.TheMovieDB.discoverMovies
    )

}
