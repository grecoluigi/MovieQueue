//
//  ViewController.swift
//  Movie Queue
//
//  Created by Luigi Greco on 01/07/2020.
//  Copyright © 2020 Luigi Greco. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var movieSuggestionLabel: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var gimmeMovieButton: UIButton!
    let genericPosterImageDataRedBlur = UIImage(named: "moviePosterGenericRedBlur")?.pngData()
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        gimmeMovieButton.layer.masksToBounds = true
        gimmeMovieButton.layer.cornerRadius = 10.0
        posterImage.image = UIImage(data: genericPosterImageDataRedBlur!)
        
    }


    @IBAction func ManageMoviesPressed(_ sender: Any) {
        print("Manage movies pressed")
    }
    
    
    @IBAction func GiveMeMoviesPressed(_ sender: Any) {
        if !MovieStore.movieStore.allMovies.isEmpty {
            let randomMovieIndex = Int.random(in: 0..<MovieStore.movieStore.allMovies.count)
            let movie = MovieStore.movieStore.allMovies[randomMovieIndex]
            if let year = movie.year {
                movieSuggestionLabel.text = "\(movie.title) \n\(year)"
            } else {
                movieSuggestionLabel.text = "\(movie.title)"
            }
            posterImage.image = UIImage(data: MovieStore.movieStore.allMovies[randomMovieIndex].thumb ?? genericPosterImageDataRedBlur!)
        } else {
            movieSuggestionLabel.text = "First add some movies to your queue!"
        }
        
    }
}

