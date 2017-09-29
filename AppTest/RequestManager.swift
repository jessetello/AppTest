//
//  DataManager.swift
//  AppTest
//
//  Created by Jesse Tello on 9/26/17.
//  Copyright © 2017 Jesse. All rights reserved.
//

import Foundation
import Alamofire

enum Endpoint: String {
    case topStories = "https://api.nytimes.com/svc/topstories/v2/home.json"
}

class RequestManager {

    static let sharedInstance = RequestManager()
    
    func getTopStories(completion:@escaping(_ success:Bool, _ result: [String: Any]?) -> Void) {
        Alamofire.request(Endpoint.topStories.rawValue, method: .get, parameters: ["api-key":"8894d54b782e44458ad1d1dd7a7536be"], encoding: URLEncoding.default, headers: nil).validate().responseJSON { response in switch response.result {
        case .success:
            guard let value = response.result.value as? [String: Any] else {
                return
            }
            completion(true, value)
            break
        case .failure:
            completion(false, nil)
            break
            }
        }
    }
    
}
