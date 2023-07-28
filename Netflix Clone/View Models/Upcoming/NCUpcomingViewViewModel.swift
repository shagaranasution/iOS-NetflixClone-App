//
//  NCUpcomingViewViewModel.swift
//  Netflix Clone
//
//  Created by Shagara F Nasution on 18/07/23.
//

import Foundation

protocol NCUpcomingViewViewModelDelegate: AnyObject {
    func didFecthInitialData()
}

final class NCUpcomingViewViewModel {
    
    weak var delegate: NCUpcomingViewViewModelDelegate?
    
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
    
    public func fetchData() {
        NCService.shared.execute(
            .listTrendingUpcomingMoviesRequest,
            expecting: NCTGetListTitlesResponse.self) { [weak self] result in
                switch result {
                case .success(let model):
                    self?.titles.append(contentsOf: model.results)
                    DispatchQueue.main.async { [weak self] in
                        self?.delegate?.didFecthInitialData()
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
