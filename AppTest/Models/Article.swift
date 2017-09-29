//
//  Article.swift
//  AppTest
//
//  Created by Jesse Tello on 9/26/17.
//  Copyright © 2017 Jesse. All rights reserved.
//

import Foundation

struct Article {
    
    var imageString: String?
    var title: String
    var publishedAt: String
    var articleUrl: String
    
    init?(data: [String:Any]) {
       guard let title = data["title"] as? String, let publishedAt = data["published_date"] as? String, let multiMedia = data["multimedia"] as? [[String: Any]], let url = data["url"] as? String else {
            return nil
        }
        let sj = multiMedia.filter { $0["format"] as? String == "superJumbo" }.first
        if let jumboMedia = sj {
            self.imageString = jumboMedia["url"] as? String
        }
        self.articleUrl = url
        self.title = title
        self.publishedAt = publishedAt.convertDate()
    }
}

extension String {
    func convertDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss-HH:SS"
        
        if let date = formatter.date(from:self) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            return dateFormatter.string(from: date)
        }
        return self
    }
}

