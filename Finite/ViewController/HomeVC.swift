//
//  HomeVC.swift
//  AntiBrowseFeed
//
//  Created by John Ababseh on 2/7/19.
//  Copyright © 2019 itsababseh. All rights reserved.
//

import UIKit
import Alamofire

enum HomeSection:Int {
    case redditTop = 0
}

class HomeVC: UIViewController, UITableViewDataSource {


    @IBOutlet weak var tableView: UITableView!

    private var sections: [HomeSection] = [.redditTop]
    private var topFiveReddit: [RedditPost] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        self.tableView.rowHeight = 100

        let nib = UINib(nibName: "RedditCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")


        fetchRedditTopSub()
    }

    // MARK: Network Request

    func fetchRedditTopSub() {
        guard let url = URL(string: "https://www.reddit.com/r/all/top.json") else {
            return
        }
        AF.request(url, method: .get).validate().responseJSON { (response) in
            guard response.result.isSuccess else {
                print("Error while fetching top posts")
                return
            }

    // MARK: Grab the top 5 post title
            if let value = response.result.value as? [String: Any] {
                for postIndex in 0..<5 {
                    let data = value["data"] as! [String: Any]
                    let children = data["children"] as! [[String: Any]]
                    let childData = children[postIndex]["data"] as! [String: Any]
                    let title = childData["title"] as! String
                    let thumbNail = childData["thumbnail"] as! String
                    var singlePost = RedditPost.init(title: title, thumbnailURL: thumbNail)
                    self.topFiveReddit.append(singlePost)
                }
            }
            self.tableView.reloadData()
        }
    }

    // MARK: TableView Protocals

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = self.sections[section]
        switch section {
        case .redditTop:
            return topFiveReddit.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = self.sections[indexPath.section]
        switch section {
        case .redditTop:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! RedditCell
            //text comes from RedditPost title, reddit post comes from the topfivereddit array
            cell.topPostLabel.text = topFiveReddit[indexPath.row].title
            //uiimage comes from redditpost
            cell.redditImageView.image = topFiveReddit[indexPath.row].thumbnailImage
            return cell
        }
    }
}
