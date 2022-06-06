//
//  APICaller.swift
//  NetflixClone
//
//  Created by Rathakrishnan Ramasamy on 25/05/22.
//

import Foundation
import UIKit

struct Constants {
    static let G_API_KEY = ""
    static let APIKEY = ""
    static let baseURL = "https://api.themoviedb.org"
    static let imageURL = "https://image.tmdb.org"
    
    static let nowPlaying = baseURL + "/3/movie/now_playing?api_key=" + APIKEY
    static let trendingMovies = baseURL + "/3/trending/movie/day?api_key=" + APIKEY
    static let trendingTvs = baseURL + "/3/trending/tv/day?api_key=" + APIKEY
    static let popularMovies = baseURL + "/3/movie/popular?api_key=" + APIKEY
    static let upcomingMovies = baseURL + "/3/movie/upcoming?api_key=" + APIKEY
    static let topRatedMovies = baseURL + "/3/movie/top_rated?api_key=" + APIKEY
    static let searchMovie = "\(baseURL)/3/search/movie?api_key=\(APIKEY)&query="
    
    static let youtubeBaseUrl = "https://youtube.googleapis.com/youtube/v3"
    
    static let originalImage =  imageURL + "/t/p/original/"
    static let thumbnailImage =  imageURL + "/t/p/w500/"
    
    static let kWidth = UIScreen.main.bounds.width
    static let kHeight = UIScreen.main.bounds.height
}

enum APIError: Error {
    case failedToGetData
}


class APICaller {
    static let shared = APICaller()
    
    
    // Get  Movies data list
    func getMoviesData(with url: String, completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let url = URL(string: url) else { return }
        let task =  URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(APIError.failedToGetData))
                return
            }
            do {
                let result = try JSONDecoder().decode(MoviesResponse.self, from: data)
                completion(.success(result.results))
            }
            catch {
                completion(.failure(error))
            }
            
            
        }
        task.resume()
    }
    
    // Search All
    func searchAll(with query: String, completion: @escaping (Result<[Movie], Error>) -> Void){
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let url = URL(string: Constants.searchMovie + query) else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(APIError.failedToGetData))
                return
            }
            do {
                let result = try JSONDecoder().decode(MoviesResponse.self, from: data)
                completion(.success(result.results))
            }
            catch {
                completion(.failure(error))
            }

        }
        task.resume()
    }
    
    
    func getMovie(with query: String, completion: @escaping (Result<YoutubeItem, Error>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let url = URL(string: "\(Constants.youtubeBaseUrl)/search?q=\(query)&key=\(Constants.G_API_KEY)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                print("can't download data")
                completion(.failure(APIError.failedToGetData))
                return
            }
            do {
//                let result = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
//                print(result)
                let result = try JSONDecoder().decode(YoutubeResponse.self, from: data)
                completion(.success(result.items[0]))
            }
            catch {
                completion(.failure(error))
            }

        }
        task.resume()
        
    }
}
