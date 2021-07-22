//
//  MovieCell.swift
//  Movie Queue
//
//  Created by Luigi Greco on 01/07/2020.
//  Copyright © 2020 Luigi Greco. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var imageThumb: UIImageView!
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
}
