//
//  TVShowsCell.swift
//  movie
//
//  Created by Shekhtman Vladyslav on 3/10/18.
//  Copyright © 2018 Shekhtman Vladyslav. All rights reserved.
//

import UIKit

protocol TVFeedCellDelegate {
    func didPressTvShowCell(sender: Any)
}

class TVFeedCell: BaseCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var delegate: TVFeedCellDelegate?
    var movies: [Movie]?
    let cellId = "cellId"
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.dataSource = self
        cv.delegate = self
        cv.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        cv.scrollIndicatorInsets = UIEdgeInsetsMake(30, 0, 0, 0)
        return cv
    }()
    
    override func setupViews() {
        super.setupViews()
        NotificationCenter.default.addObserver(self, selector: #selector(fetchTvShows), name: NSNotification.Name("SearchTvShows"), object: nil)
        
        collectionView.register(TvShowCell.self, forCellWithReuseIdentifier: cellId)
        
        addSubview(collectionView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView)
    }
    
    // Mark: CollectionView functions
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? TvShowCell else { return UICollectionViewCell() }
//        cell.movie = movies?[indexPath.item]
        cell.movie = movies?[indexPath.item]
        cell.addToFavoriteButton.isUserInteractionEnabled = true
        cell.addToFavoriteButton.addTarget(self, action: #selector(addToFavoriteBtnPressed(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didPressTvShowCell(sender: movies![indexPath.row])
    }
    
    // Mark: Functions
    
    
    // Mark: Selector handlers
    @objc func addToFavoriteBtnPressed(sender: UIButton) {
        guard let cell = sender.superview as? UICollectionViewCell else { return }
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        
        let movie = movies![indexPath.item]
    }
    
    @objc func fetchTvShows(notification: NSNotification) {
        guard let searchQuery = notification.userInfo?["searchQuery"] as? String else { return }
        
        ApiService.sharedInstance.retrieveTvShowsJson(searchQuery: searchQuery) { (movies: [Movie]) in
            self.movies = movies
            self.collectionView.reloadData()
        }
    }

}









