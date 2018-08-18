//
//  HNSubmission.swift
//  HackerNews
//
//  Created by Muhammed Cavusoglu on 19.08.2018.
//  Copyright © 2018 Muhammed Cavusoglu. All rights reserved.
//

import Foundation

struct Submission {
    let title: String
    let url: String?
    let by: String
    let score: Int
    let descendants: Int?
    let time: Int
}
