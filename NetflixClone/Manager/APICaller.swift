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
    static let imageURL = "https://image.tmdb.org"
    
    static let trendingMovies = baseURL + "/3/trending/movie/day?api_key=" + APIKEY
    static let trendingTvs = baseURL + "/3/trending/tv/day?api_key=" + APIKEY
    static let popularMovies = baseURL + "/3/movie/popular?api_key=" + APIKEY
    static let upcomingMovies = baseURL + "/3/movie/upcoming?api_key=" + APIKEY
    static let topRatedMovies = baseURL + "/3/movie/top_rated?api_key=" + APIKEY
    
    static let originalImage =  imageURL + "/t/p/original/"
    static let thumbnailImage =  imageURL + "/t/p/w500/"
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
    
    
}
