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
    let thumb: Data?
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

//struct MovieResponse: Decodable {
//    let results: [Movie]
//}
//
//struct Movie: Decodable {
//    let id: Int
//    let title: String
//    let year: Int
//    let thumb: Data?
//
//}


//class Movie: Equatable, Codable {
//    var title: String
//    var year: Int
//    var thumb: Data?
//
//    init(title: String, year: Int, thumb: UIImage?){
//        self.title = title
//        self.year = year
//        self.thumb = thumb?.pngData()
//    }
//
//    convenience init(random: Bool = false) {
//        if random {
//            let articles = ["A", "The", "One"]
//            let adjectives = ["Quiet", "New", "Cool", "Dark", "Beautiful"]
//            let nouns = ["Place", "Morning", "Day", "Night", "Year", "Son", "Mother", "Friend"]
//            let randomArticle = articles.randomElement()!
//            let randomAdjective = adjectives.randomElement()!
//            let randomNoun = nouns.randomElement()!
//            let randomName = "\(randomArticle) \(randomAdjective) \(randomNoun)"
//            let randomYear = Int.random(in: 1980..<2020)
//            let defaultThumb = UIImage(named: "moviePosterGeneric")
//            self.init(title: randomName, year: randomYear, thumb: defaultThumb)
//        } else {
//            self.init(title: "", year: 0, thumb: nil)
//        }
//    }
//
//    static func ==(lhs: Movie, rhs: Movie) -> Bool {
//        return lhs.title == rhs.title && lhs.year == rhs.year
//    }
//}
