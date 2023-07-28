//
//  NCDownloadsViewViewModel.swift
//  Netflix Clone
//
//  Created by Shagara F Nasution on 26/07/23.
//

import Foundation

protocol NCDownloadsViewViewModelDelegate: AnyObject {
    func didFetchDownloadedTitle()
}

final class NCDownloadsViewViewModel {
    
    public weak var delegate: NCDownloadsViewViewModelDelegate?
    
    private var titleItems: [TitleItem] = [] {
        didSet {
            titles = titleItems.compactMap({ item in
                NCTitle(id: Int(item.id), mediaType: item.mediaType, originalName: item.originalName, originalTitle: item.originalTitle, posterPath: item.posterPath, overview: item.overview, voteCount: Int(item.voteCount), releaseDate: item.releaseDate, voteAverage: item.voteAverage)
            })
        }
    }
    
    private var titles: [NCTitle] = [] {
        didSet {
            cellViewModels = titles.compactMap({ title in
                NCTitleTableViewCellViewModel(title: title)
            })
        }
    }
    
    public private(set) var cellViewModels: [NCTitleTableViewCellViewModel] = []
    
    init() {}
    
    public func fetchDownloadedTitle() {
        NCDataPersistenceManager.shared.fetchDataFromDataBase { [weak self] result in
            switch result {
            case .success(let model):
                self?.titleItems = model

                DispatchQueue.main.async {
                    self?.delegate?.didFetchDownloadedTitle()
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    public func removeDownloadedTitle(at index: Int, completion: () -> Void) {
        NCDataPersistenceManager.shared.deleteDataFromDataBase(data: titleItems[index]) { [weak self] result in
            switch result {
            case .success():
                self?.titleItems.remove(at: index)
                completion()
            case .failure(let error):
                print(String(describing: error))
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
