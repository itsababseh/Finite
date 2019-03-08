//
//  RedditPost.swift
//  AntiBrowseFeed
//
//  Created by John Ababseh on 2/28/19.
//  Copyright © 2019 itsababseh. All rights reserved.
//

import Foundation
import UIKit

class RedditPost: NSObject {

    var title: String
    var thumbnailImage: UIImage?

    init(title: String, thumbnailURL: String?) {
        self.title = title

        if let thumbnailURL = thumbnailURL {
            guard let imageURL = URL(string: thumbnailURL) else {
                return
            }
            if let data = try? Data(contentsOf: imageURL) {
                if let image: UIImage = UIImage(data: data) {
                    self.thumbnailImage = image
                }
            }
        }
    }

}


