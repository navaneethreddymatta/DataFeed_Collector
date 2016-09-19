//
//  App.swift
//  InClass07
//
//  Created by student on 7/26/16.
//  Copyright © 2016 MNR_iOS. All rights reserved.
//


import Foundation

class App {
    var category: String?
    var artist: String?
    var name: String?
    var squareImage: String?
    var otherImage: String?
    var releaseDate: String?
    var summary: String?
    var price: String?
    
    init(category: String?, artist: String?, name: String?, squareImage: String?, otherImage: String?, releaseDate: String?, summary: String?, price: String?) {
        self.category = category
        self.artist = artist
        self.name = name
        self.squareImage = squareImage
        self.otherImage = otherImage
        self.releaseDate = releaseDate
        self.summary = summary
        self.price = price
    }
}