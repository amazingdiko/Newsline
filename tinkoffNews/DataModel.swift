//
//  DataModel.swift
//  tinkoffNews
//
//  Created by Vitaliy Plaschenkov on 04.02.2023.
//

import Foundation


struct Articles: Codable{
    var urlToImage: String = ""
    var title: String = ""
    var description: String = ""
    var url: String = ""
    var author: String = ""
    var publishedAt: String = ""
    var content: String = ""
}

struct News: Codable{
    var articles: [Articles] = []
}
