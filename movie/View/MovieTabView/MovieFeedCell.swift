//
//  FeedCell.swift
//  movie
//
//  Created by Shekhtman Vladyslav on 3/9/18.
//  Copyright © 2018 Shekhtman Vladyslav. All rights reserved.
//

import UIKit

protocol FilmCellDelegate {
    func didPressCell(sender: Any)
}

class MovieFeedCell: BaseCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var delegate: FilmCellDelegate?
    var films: [Film]?
    let cellId = "cellId"
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    let gifWebView: UIWebView = {
        let webView = UIWebView()
        webView.backgroundColor = .blue
        let url = Bundle.main.url(forResource: "typing", withExtension: "gif")!
        let data = try! Data(contentsOf: url)
        webView.load(data, mimeType: "image/gif", textEncodingName: "UTF-8", baseURL: NSURL() as URL)
        webView.scalesPageToFit = true
        webView.contentMode = UIViewContentMode.scaleAspectFit
        webView.layer.cornerRadius = 90
        webView.isUserInteractionEnabled = false
        webView.clipsToBounds = true
        return webView
    }()
    
    let greeetingsLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Tap on magnifying glass to look for favorite movies"
        lbl.font = UIFont(name: "Helvetica-Bold", size: 18)
        lbl.numberOfLines = 2
        lbl.textAlignment = .center
        return lbl
    }()
    
    override func setupViews() {
        super.setupViews()

        NotificationCenter.default.addObserver(self, selector: #selector(fetchMovies), name: NSNotification.Name("SearchMovies"), object: nil)
        
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: cellId)
        
        addSubview(collectionView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView)
        
        collectionView.addSubview(gifWebView)
        collectionView.addConstraintsWithFormat(format: "H:[v0(180)]", views: gifWebView)
        collectionView.addConstraintsWithFormat(format: "V:[v0(180)]", views: gifWebView)
        collectionView.addConstraint(NSLayoutConstraint(item: gifWebView, attribute: .centerY, relatedBy: .equal, toItem: self.collectionView, attribute: .centerY, multiplier: 1, constant: -80))
        collectionView.addConstraint(NSLayoutConstraint(item: gifWebView, attribute: .centerX, relatedBy: .equal, toItem: self.collectionView, attribute: .centerX, multiplier: 1, constant: 0))
        
        collectionView.addSubview(greeetingsLabel)
        collectionView.addConstraintsWithFormat(format: "H:[v0(240)]", views: greeetingsLabel)
        collectionView.addConstraintsWithFormat(format: "V:[v0(60)]", views: greeetingsLabel)
        collectionView.addConstraint(NSLayoutConstraint(item: greeetingsLabel, attribute: .centerY, relatedBy: .equal, toItem: gifWebView, attribute: .centerY, multiplier: 1, constant: 150))
        collectionView.addConstraint(NSLayoutConstraint(item: greeetingsLabel, attribute: .centerX, relatedBy: .equal, toItem: gifWebView, attribute: .centerX, multiplier: 1, constant: 0))
    }
    
    //  Mark: CollectionView functions
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return films?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as? MovieCell else { return UICollectionViewCell() }
        cell.film = films?[indexPath.item]
        cell.addToFavoriteButton.isUserInteractionEnabled = true
        cell.addToFavoriteButton.addTarget(self, action: #selector(addToFavoriteBtnPressed(sender:)), for: .touchUpInside)
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didPressCell(sender: films![indexPath.row])
    }
    
    // Mark: Selector handlers
    @objc func addToFavoriteBtnPressed(sender: UIButton) {
        guard let cell = sender.superview as? UICollectionViewCell else { return }
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        
        let film = films![indexPath.item]
        
        // save selected film to core data
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let filmEntity = FilmMO(context: context)
        filmEntity.overview = film.overview
        filmEntity.posterName = film.posterName
        filmEntity.rating = film.rating!
        filmEntity.title = film.title
        filmEntity.year = film.year
        filmEntity.type = film.type
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        print("saved film to core data")
    }
    
    @objc func fetchMovies(notification: NSNotification) {
        greeetingsLabel.isHidden = true
        gifWebView.isHidden = true
        
        guard let searchQuery = notification.userInfo?["searchQuery"] as? String else { return }
        
        ApiService.sharedInstance.retrieveMoviesJson(searchQuery: searchQuery) { (films: [Film]) in
            self.films = films
            self.collectionView.reloadData()
        }
    }
    
}
