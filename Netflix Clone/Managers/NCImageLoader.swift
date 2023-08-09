//
//  NCImageLoader.swift
//  Netflix Clone
//
//  Created by Shagara F Nasution on 09/08/23.
//

import Foundation

final class NCImageLoader {
    
    static let shared = NCImageLoader()
    
    private var imageDataCache = NSCache<NSString, NSData>()
    
    private init() {}
    
    // Network data with URLSession Async/Await
    public func download(from url: URL) async throws -> Data {
        let key = url.absoluteString as NSString
        
        if let cachedData = imageDataCache.object(forKey: key) {
            return cachedData as Data
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        
        imageDataCache.setObject(data as NSData, forKey: key)
        
        return data
    }
    
}
