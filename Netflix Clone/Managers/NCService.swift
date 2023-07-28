//
//  NCService.swift
//  Netflix Clone
//
//  Created by Shagara F Nasution on 13/07/23.
//

import Foundation

final class NCService {
    static let shared = NCService()
    
    private init() {}
    
    private enum APIErrors: Error {
        case failToCreateRequest
        case failToGetData
        case failToDecodeData
    }
    
    public func execute<T: Codable>(
        _ request: NCRequest,
        expecting type: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        guard let urlRequest = self.request(from: request) else {
            return completion(.failure(APIErrors.failToCreateRequest))
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            guard let data, error == nil else {
                return completion(.failure(error ?? APIErrors.failToCreateRequest))
            }
            
            do {
                let results = try JSONDecoder().decode(type, from: data)
                return completion(.success(results))
            } catch {
                print(String(describing: error))
                return completion(.failure(APIErrors.failToDecodeData))
            }
        }
        task.resume()
    }
    
    private func request(from ncRequest: NCRequest) -> URLRequest? {
        guard let url = ncRequest.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = ncRequest.httpMethod
    
        return request
    }
}
