//
//  Movie.swift
//  Movie Queue
//
//  Created by Luigi Greco on 03/07/2020.
//  Copyright © 2020 Luigi Greco. All rights reserved.
//

import UIKit

class Movie: Equatable, Codable {
    let title: String
    let id: Int?
    let poster_path: URL?
    var thumb: Data?
    var year: Int?
    var isAddedToList: Bool?
    private let release_date: String?
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()
    
    var releaseDate: Date? {
        if  let dateString = release_date,
            let date = Self.dateFormatter.date(from: dateString) {
            return date
        } else {
            return nil
        }
    }

    init(title: String, year: Int, thumb: UIImage?, id: Int?, release_date: String?){
            self.title = title
            self.year = year
            self.thumb = thumb?.pngData()
            self.id = id
            self.poster_path = nil //TODO sistemare
            self.release_date = release_date
            self.isAddedToList = false
        }
        static func ==(lhs: Movie, rhs: Movie) -> Bool {
            return lhs.title == rhs.title && lhs.release_date == rhs.release_date
        }
}
