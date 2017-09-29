//
//  ArticleCollectionViewCell.swift
//  AppTest
//
//  Created by Jesse Tello on 9/26/17.
//  Copyright © 2017 Jesse. All rights reserved.
//

import UIKit

class ArticleCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var articlePublished: UILabel!
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var articleTitle: UILabel!
    
    override func prepareForReuse() {
        articleImage.image = nil
    }
}
