//
//  ManageTitlesController.swift
//  Movie Queue
//
//  Created by Luigi Greco on 01/07/2020.
//  Copyright © 2020 Luigi Greco. All rights reserved.
//

import UIKit

class ManageTitlesController: UITableViewController {

    var isEditingMode = false
    let genericPosterImageDataRedBlur = UIImage(named: "moviePosterGenericRedBlur")?.pngData()
    let genericPosterImageData = UIImage(named: "moviePosterGeneric")?.pngData()
    @IBOutlet weak var addMovieBarButtonItem: UIBarButtonItem!
    
    func tableView(_ tableView: UITableView, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: tableView.frame.width - 10, height: tableView.frame.width/2.5)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MovieStore.movieStore.allMovies.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height / 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = MovieStore.movieStore.allMovies[indexPath.row]
        cell.titleLabel.text = movie.title
        if let year = movie.year {
            cell.yearLabel.text = "\(year)"
        } else {
            cell.yearLabel.text = "No release date available"
        }
        cell.imageThumb.image = UIImage(data: movie.thumb ?? genericPosterImageData!)
        cell.selectionStyle = .none
//        cell.imageThumb.clipsToBounds = true
//        cell.imageThumb.layer.cornerRadius = 20.0
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let movie = MovieStore.movieStore.allMovies[indexPath.row]
            MovieStore.movieStore.removeMovie(movie)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedMovie = MovieStore.movieStore.allMovies[sourceIndexPath.row]
        MovieStore.movieStore.removeMovie(movedMovie)
        MovieStore.movieStore.allMovies.insert(movedMovie, at: destinationIndexPath.row)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        tableView.reloadData()
    }
    
    @IBAction func unwindToViewControllerA(segue: UIStoryboardSegue) {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        tableView.delegate = self
        tableView.dataSource = self
        //navBarTitle.title = "Manage movies"
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 128
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadData), name: NSNotification.Name(rawValue: "ReloadData"), object: nil)
    }


    
    @objc func reloadData() {
        tableView.reloadData()
        print("reload data called")
    }

    @IBAction func toggleEditingMode(_ sender: UIBarButtonItem) {
        if isEditing {
            sender.title = "Edit"
            //sender.setTitle("Edit", for: .normal)
            setEditing(false, animated: true)
        } else {
            sender.title = "Done"
            //sender.setTitle("Done",for: .normal)
            setEditing(true, animated: true)
        }
    }
}
