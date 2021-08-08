//
//  MovieStore.swift
//  Movie Queue
//
//  Created by Luigi Greco on 03/07/2020.
//  Copyright © 2020 Luigi Greco. All rights reserved.
//

import UIKit

enum MovieError: Error {
    case imageCreationError
    case missingImageURL
}

class MovieStore {
    var allMovies = [Movie]()
    static let movieStore = MovieStore()
    let genericPosterImageData = UIImage(named: "moviePosterGeneric")?.pngData()
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    func searchMovies(query: String, completion: @escaping (Result<[Movie], Error>) -> Void){
        let url = TMDB_API.movieSearchURL(query: query)
        print(url)
        DispatchQueue.main.async {
            let request = URLRequest(url: url)
            let task = self.session.dataTask(with: request){
                (data,response,error) in
                let result = self.processMoviesRequest(data: data, error: error)
                OperationQueue.main.addOperation {
                    completion(result)
                }
            }
            task.resume()
        }
        
    }

    private func processMoviesRequest(data: Data?, error: Error?) -> Result<[Movie], Error> {
        guard let jsonData = data else {
            return .failure(error!)
        }
        return TMDB_API.movies(fromJSON: jsonData)
    }
    
    func processImageRequest(data: Data?, error: Error?) -> Result<UIImage, Error> {
        guard
            let imageData = data,
            let image = UIImage(data: imageData) else {
            // Couldn't create an image
            if data == nil {
                return .failure(error!)
            } else {
                return .failure(MovieError.imageCreationError)
            }
        }
        return .success(image)
    }
    
    func fetchImage(for movie: Movie, completion: @escaping (Result<UIImage, Error>)-> Void) {
        guard let posterURL = movie.poster_path else {
            completion(.failure(MovieError.missingImageURL))
            return
        }
        let request = URLRequest(url: posterURL)
        
        let task = session.dataTask(with: request) {
            (data,response, error) in
            let result = self.processImageRequest(data: data, error: error)
            OperationQueue.main.addOperation {
                completion(result)
            }
        }
        task.resume()
    }
    
    let movieArchiveURL: URL = {
        let documentsDiretories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDiretories.first!
        return documentDirectory.appendingPathComponent("movies.plist")
    }()
    
//    @discardableResult func addTestMovie() -> Movie {
//        let testMovie = Movie(random: true)
//        allMovies.append(testMovie)
//        return testMovie
//    }
//
    @discardableResult func addMovie(title: String, year: Int, poster: UIImage?) -> Movie {
        let movie = Movie(title: title, year: year, thumb: poster, id: nil, release_date: nil)
        allMovies.append(movie)
        return movie
    }

    @discardableResult func addMovie(title: String, year: Int) -> Movie {
        let movie = Movie(title: title, year: year, thumb: nil, id: nil, release_date: nil)
        allMovies.append(movie)
        return movie
    }
    
    @discardableResult func addMovie(movie: Movie) -> Movie {
        var movieThumb = UIImage()
        if let posterPath = movie.poster_path {
            let url = URL(string: "https://image.tmdb.org/t/p/original/\(posterPath)")!
            if let data = try? Data(contentsOf: url) { movieThumb = UIImage(data: data)! }
            else { movieThumb = UIImage(data: self.genericPosterImageData!)! }
        }
        let newMovie = Movie(title: movie.title, year: movie.year ?? 0000, thumb: movieThumb, id: nil, release_date: nil)
        allMovies.append(newMovie)
        return newMovie
    }
    
//
    func removeMovie(_ movie: Movie) {
        if let index = allMovies.firstIndex(of: movie) {
            allMovies.remove(at: index)
        }
    }
    
    init() {
        do {
            let data = try Data(contentsOf: movieArchiveURL)
            let unarchiver = PropertyListDecoder()
            let movies = try unarchiver.decode([Movie].self, from: data)
            allMovies = movies
        } catch {
            print("Error handling in saved items: \(error)")
        }
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(saveChanges), name: UIScene.didEnterBackgroundNotification, object: nil)
    }
    
    @objc func saveChanges() -> Bool {
        print("Saving items to: \(movieArchiveURL)")
        do {
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(allMovies)
            try data.write(to: movieArchiveURL, options: [.atomic])
            print("Saved all of the movies")
            return true
        } catch let encodingError {
            print("Error encoding allItems: \(encodingError)")
            return false
        }
        
    }
}
