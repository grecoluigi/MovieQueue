//
//  TMDB_API.swift
//  TMDB api test
//
//  Created by Luigi Greco on 18/07/21.
//

import Foundation

enum EndPoint: String {
    case searchMovie = "search/movie"
}

struct TMDB_API {
    private static let baseURLString = "https://api.themoviedb.org/3/search/movie"
    private static let apiKey = "8d5b060be6f77119571d881cd1328370"
    private static func tmdbURL(endpoint: EndPoint, parameters: [String:String]?) -> URL {
        var components = URLComponents(string: baseURLString)!
        var queryItems = [URLQueryItem]()
        let baseParams = [
            //"method" : endpoint.rawValue,
            "api_key" : apiKey,
            "page" : "1"
        ]
        for (key, value) in baseParams {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        if let additionalParams = parameters {
            for(key,value) in additionalParams {
                let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        }
        components.queryItems = queryItems
        return components.url!
    }
    
    static func movieSearchURL(query: String) -> URL {
        return tmdbURL(endpoint: .searchMovie, parameters: ["query" : query])
    }
    
//    static var movieSearchURL: URL { return tmdbURL(endpoint: .searchMovie, parameters: ["query" : "Avengers"])
//        }
    
    static func movies(fromJSON data: Data) -> Result<[Movie], Error> {
        do {
            let decoder = JSONDecoder()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            let tmdbResponse = try decoder.decode(tmdbResponse.self, from: data)
            let movies = tmdbResponse.movies.filter { $0.poster_path != nil && $0.releaseDate != nil}
            //TODO filtro i risultanti senza poster e senza data, posso considerare di trattare il caso in cui siano nil ma vista la rarità dei film senza anno per adesso li salto
            return .success(movies)
        } catch {
            return .failure(error)
        }
    }
}

struct tmdbResponse: Codable {
    let movies: [Movie]
    enum CodingKeys: String, CodingKey {
        case movies = "results"
    }
}

