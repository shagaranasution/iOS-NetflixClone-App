//
//  NCSearchViewViewModel.swift
//  Netflix Clone
//
//  Created by Shagara F Nasution on 19/07/23.
//

import UIKit

protocol NCSearchViewViewModelDelegate: AnyObject {
    func didFecthDiscoverMovies()
}

final class NCSearchViewViewModel {

    weak var delegate: NCSearchViewViewModelDelegate?
    
    private var titles: [NCTitle] = [] {
        didSet {
            for title in titles {
                let viewModel = NCTitleTableViewCellViewModel(title: title)
                cellViewModels.append(viewModel)
            }
        }
    }
    
    public private(set) var cellViewModels: [NCTitleTableViewCellViewModel] = []
    
    init() {}
    
    public func fetchDiscoverMovies() {
        NCService.shared.execute(
            .listDiscoverMoviesRequest,
            expecting: NCTGetListTitlesResponse.self) { result in
            
                switch result {
                case .success(let model):
                    self.titles.append(contentsOf: model.results)
                    DispatchQueue.main.async { [weak self] in
                        self?.delegate?.didFecthDiscoverMovies()
                    }
                case .failure(let error):
                    print("Error: \(String(describing: error))")
                }
        }
    }
    
    public func getTitle(at index: Int) -> NCTitle? {
        guard index < cellViewModels.count else {
            return nil
        }
        
        return titles[index]
    }
    
}
