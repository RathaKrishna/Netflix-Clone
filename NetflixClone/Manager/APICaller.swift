//
//  APICaller.swift
//  NetflixClone
//
//  Created by Rathakrishnan Ramasamy on 25/05/22.
//

import Foundation

struct Constants {
    static let APIKEY = "60ae421fc805298e8f801d4287e3d4c2"
    static let baseURL = "https://api.themoviedb.org"
    
    static let trendingMovies = baseURL + "/3/trending/movie/day?api_key=" + APIKEY
    static let trendingTvs = baseURL + "/3/trending/tv/day?api_key=" + APIKEY
    static let popularMovies = baseURL + "/3/movie/popular?api_key=" + APIKEY
    static let upcomingMovies = baseURL + "/3/movie/upcoming?api_key=" + APIKEY
    static let topRatedMovies = baseURL + "/3/movie/top_rated?api_key=" + APIKEY
    
}

enum APIError: Error {
        case failedToGetData
    }
    

class APICaller {
    static let shared = APICaller()
    
    
    // Get Trending Movies list
    func getTrendingMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let url = URL(string: Constants.trendingMovies) else { return }
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
    
    // Get Trending TV list
    func getTrendingTv(completion: @escaping (Result<[TV], Error>) -> Void) {
        guard let url = URL(string: Constants.trendingTvs) else { return }
        let task =  URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(APIError.failedToGetData))
                return
            }
            do {
                let result = try JSONDecoder().decode(TrendingTVResponse.self, from: data)
                completion(.success(result.results))
            }
            catch {
                completion(.failure(error))
            }
            

        }
        task.resume()
    }
    
    // Get Popular Movies list
    func getPopularMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let url = URL(string: Constants.popularMovies) else { return }
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
    
    // Get Upcoming Movies list
    func getUpcomingMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let url = URL(string: Constants.upcomingMovies) else { return }
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
    
    // Get Top Rated Movies list
    func getTopRatedMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let url = URL(string: Constants.topRatedMovies) else { return }
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
    
}
