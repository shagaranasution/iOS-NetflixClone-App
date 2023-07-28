//
//  NCDataPersistenceManager.swift
//  Netflix Clone
//
//  Created by Shagara F Nasution on 26/07/23.
//

import Foundation
import UIKit
import CoreData

class NCDataPersistenceManager {
    
    static let shared = NCDataPersistenceManager()
    
    enum DataPersistenceManagerError: Error {
        case failedToSaveData
        case failedToFetchData
        case failedToDeleteData
    }
    
    private init() {}
    
    public func downloadTitle(
        model: NCTitle,
        completion: @escaping (Result<Void, Error>) -> Void
    ) -> Void {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let item = TitleItem(context: context)
        item.id = Int64(model.id)
        item.mediaType = model.mediaType
        item.originalName = model.originalName
        item.originalTitle = model.originalTitle
        item.posterPath = model.posterPath
        item.overview = model.overview
        item.releaseDate = model.releaseDate
        item.voteCount = Int64(model.voteCount)
        item.voteAverage = model.voteAverage
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DataPersistenceManagerError.failedToSaveData))
        }
    }
    
    public func fetchDataFromDataBase(completion: (Result<[TitleItem], Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<TitleItem>
        request = TitleItem.fetchRequest()
        
        do {
            let titles = try context.fetch(request)
            completion(.success(titles))
        } catch {
            completion(.failure(DataPersistenceManagerError.failedToFetchData))
        }
        
    }
    
    public func deleteDataFromDataBase(data: TitleItem, completion: (Result<(), Error>) -> Void) -> Void {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        context.delete(data)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DataPersistenceManagerError.failedToDeleteData))
        }
    }
    
}
