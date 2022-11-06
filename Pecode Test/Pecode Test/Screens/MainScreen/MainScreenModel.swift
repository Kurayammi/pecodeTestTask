//
//  MainScreenModel.swift
//  Pecode Test
//
//  Created by Kito on 11/6/22.
//

import UIKit

struct ArticlesModel {
    let source: String
    let author: String
    let title: String
    let description: String
    let url: String
    let image: UIImage?
    let publishedAt: String
    var isSaved = false
}
