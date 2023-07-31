//
//  NCHeroHeaderViewViewModel.swift
//  Netflix Clone
//
//  Created by Shagara F Nasution on 25/07/23.
//

import Foundation

protocol NCHeroHeaderViewViewModelDelegate: AnyObject {
    func didDownloadTitle(result: Result<Void, Error>)
}

final class NCHeroHeaderViewViewModel {
    
    public weak var delegate: NCHeroHeaderViewViewModelDelegate?
    
    private let model: NCTitle
    
    init(model: NCTitle) {
        self.model = model
    }
    
    public var title: NCTitle {
        return model
    }
    
    public var posterUrl: URL? {
        return URL(string: "https://image.tmdb.org/t/p/w500\(title.posterPath ?? "")")
    }
    
    public func downloadTitle() {
        NCDataPersistenceManager.shared.downloadTitle(
            model: model) { [weak self] result in
                self?.delegate?.didDownloadTitle(result: result)
            }
    }

}
