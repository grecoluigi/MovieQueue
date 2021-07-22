//
//  AddMovieController.swift
//  Movie Queue
//
//  Created by Luigi Greco on 21/08/20.
//  Copyright © 2020 Luigi Greco. All rights reserved.
//

import UIKit

class SearchMovieController : UITableViewController, UISearchBarDelegate {
    let genericPosterImageData = UIImage(named: "moviePosterGeneric")?.pngData()

    @IBOutlet var searchBar: UISearchBar!
    var store = MovieStore()
    var movieResults = [Movie]()
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        searchBar.delegate = self
        searchBar.showsBookmarkButton = true
        searchBar.setImage(UIImage(systemName: "plus.square.fill.on.square.fill"), for: .bookmark, state: .normal)
//        store.searchMovies(query: "Avengers") { (moviesResult) in
//            switch moviesResult {
//            case let .success(movies):
//                print("Obtained \(movies.count) movies correctly")
//                for movie in movies {
//                    self.movieResults.append(movie)
//                    print("Name: \(movie.title), Poster URL: \(movie.poster_path!), Released: \(movie.releaseDate!)")
//                    self.tableView.reloadData()
//                }
//                // Arrivato qui ho un array di movies
//            case let .failure(error):
//                print(error)
//            }
//
//        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 128
    }
    
    func tableView(_ tableView: UITableView, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: tableView.frame.width - 10, height: tableView.frame.width/2.5)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieResults.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height / 5
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            print("Search: \(searchText)")
        store.searchMovies(query: searchText) { (moviesResult) in
            switch moviesResult {
            case let .success(movies):
                self.movieResults.removeAll()
                for movie in movies {
                    self.movieResults.append(movie)
                    print("Name: \(movie.title), Poster URL: \(movie.poster_path!), Released: \(movie.releaseDate!)")
                }
                self.tableView.reloadData()
            case let .failure(error):
                print(error)
            }
           
        }
        }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchMovieCell", for: indexPath) as! SearchMovieCell
        let movie = movieResults[indexPath.row]
        DispatchQueue.main.async {
            cell.titleLabel.text = movie.title
            if let posterPath = movie.poster_path {
                let url = URL(string: "https://image.tmdb.org/t/p/original/\(posterPath)")!
                if let data = try? Data(contentsOf: url) { cell.posterImgView.image = UIImage(data: data) }
            else { cell.posterImgView.image = UIImage(data: self.genericPosterImageData!) }
            }
        }
        //cell.yearLabel.text = String(movie.releaseDate)
        //cell.imageThumb.image = UIImage(data: movie.thumb ?? genericPosterImageData!)
        //cell.selectionStyle = .none
//        cell.imageThumb.clipsToBounds = true
//        cell.imageThumb.layer.cornerRadius = 20.0

        return cell
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        view.endEditing(true)
        self.performSegue(withIdentifier: "ManageMovies", sender: self)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("selected cell \(indexPath.row)")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        searchBar.resignFirstResponder()
    }
    
    @objc func reloadData() {
        tableView.reloadData()
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        let addManuallyVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddManuallyController") as! AddManuallyController
        self.present(addManuallyVC, animated: true, completion: nil)
    }

}

