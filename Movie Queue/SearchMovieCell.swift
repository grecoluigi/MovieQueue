//
//  SearchMovieCell.swift
//  Movie Queue
//
//  Created by Luigi Greco on 20/07/21.
//  Copyright © 2021 Luigi Greco. All rights reserved.
//

import UIKit

class SearchMovieCell: UITableViewCell {
    let genericPosterImageData = UIImage(named: "moviePosterGeneric")?.pngData()
    @IBOutlet weak var posterImgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = "Loading..."
        posterImgView.image = UIImage(data: self.genericPosterImageData!)
        backgroundColor = UIColor.clear
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cellTapped(_:))))
    }
    
    @objc func cellTapped(_ sender: UITapGestureRecognizer) {
        print(titleLabel.text!)
        MovieStore.movieStore.addMovie(title: titleLabel.text!, year: 0000, poster: posterImgView.image)
        self.backgroundColor = UIColor.systemGreen
    }
}


