//
//  DataPersistanceManager.swift
//  NetflixClone
//
//  Created by Rathakrishnan Ramasamy on 02/06/22.
//

import Foundation
import UIKit
import CoreData

class DataPersistanceManager {
    static let shared = DataPersistanceManager()
    
    func downloadMovieWith(model: Movie, completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        let context = appDelegate.persistentContainer.viewContext
        
        let item = MovieItem(context: context)
        
        item.id = Int64(model.id)
        item.overview = model.overview
        item.original_title = model.original_title
        
       
        item.media_type = model.media_type
        item.title = model.title
        item.poster_path = model.poster_path
        item.backdrop_path = model.backdrop_path
        item.vote_count = Int64(model .vote_count)
        item.release_date = model.release_date
        item.vote_average = model.vote_average
        item.name = model.name
        item.original_name = model.original_name
        item.first_air_date = model.first_air_date
        
        do {
            try context.save()
            completion(.success(()))
        }
        catch {
            
            print(error.localizedDescription)
            completion(.failure(error))
        }
        
    }
    
    func fetchMoviesFromDB(completion: @escaping (Result<[MovieItem], Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<MovieItem> = MovieItem.fetchRequest()
        
        do {
            let result = try context.fetch(request)
            completion(.success(result))
        }
        catch {
            completion(.failure(error))
        }
    }
    
    func deleteMovieFromDB(model: MovieItem, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(model)
        do{
            try context.save()
            completion(.success(()))
        }
        catch {
            completion(.failure(error))
        }
    }
}
