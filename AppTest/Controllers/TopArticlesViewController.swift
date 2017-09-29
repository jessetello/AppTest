//
//  ViewController.swift
//  AppTest
//
//  Created by Jesse Tello on 9/26/17.
//  Copyright © 2017 Jesse. All rights reserved.
//

import UIKit

private let reuseArticleIdentifier = "ArticleCell"

class TopArticlesViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var articles = [Article?]()
    var selectedArticle: Article?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getArticles()   
    }
    
    func getArticles() {
        RequestManager.sharedInstance.getTopStories { [weak self] success, results in
            if success {
                guard let data = results?["results"] as? [[String: Any]] else {
                    return
                }
                for obj in data {
                    self?.articles.append(Article(data: obj))
                }
                
                //Remove any nils
                if (self?.articles.count)! > 0 {
                    self?.articles = (self?.articles.flatMap { $0 })!
                }
                self?.collectionView.reloadData()
            }
            else {
                //show error
            }
        }
    }
}

extension TopArticlesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articles.count
    }    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseArticleIdentifier, for: indexPath) as? ArticleCollectionViewCell else {
            fatalError("Expected type for reuseIdentifier. Check the configuration in Main.storyboard.")
        }
        configure(cell: cell, at: indexPath)
        return cell
    }
    
    private func configure(cell: ArticleCollectionViewCell, at indexPath: IndexPath) {
        cell.articleTitle.text = articles[indexPath.row]?.title
        cell.articlePublished.text = articles[indexPath.row]?.publishedAt
        if let urlString = articles[indexPath.row]?.imageString {
           cell.articleImage.downloadedFrom(link: urlString)
        }
        else {
           cell.articleImage.image = UIImage(named: "Holder")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "details" {
            let vc = segue.destination as? ArticleDetailsViewController
            if let selected = selectedArticle {
                vc?.article = selected
            }
        }
    }
}

extension TopArticlesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       selectedArticle = articles[indexPath.row]
       performSegue(withIdentifier: "details", sender: nil)
    }
}

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFill) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
                DispatchQueue.main.async() { () -> Void in
                    self.image = image
                    //If gradient does not exist, add it
                    if self.layer.sublayers?.count == nil {
                        let gradient = CAGradientLayer()
                        gradient.frame = self.bounds
                        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
                        self.layer.insertSublayer(gradient, at: 0)
                    }
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFill) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}

