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
    @IBOutlet weak var yearLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = "Loading..."
        yearLabel.text = ""
        posterImgView.image = nil
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}


