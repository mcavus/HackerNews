//
//  HNTableViewCell.swift
//  HackerNews
//
//  Created by Muhammed Cavusoglu on 18.08.2018.
//  Copyright © 2018 Muhammed Cavusoglu. All rights reserved.
//

import UIKit

class HNTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var pointsAndByLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descendantsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(s: Submission) {
        titleLabel.text = s.title
        urlLabel.text = s.url
        pointsAndByLabel.text = String(s.score) + " points by " + s.by
        timeLabel.text = self.timeAgoSinceDate(timeStamp: Double(s.time))
        
        if let dCount = s.descendants {
            descendantsLabel.text = String(dCount)
        } else {
            descendantsLabel.text = "0"
        }
    }
}
