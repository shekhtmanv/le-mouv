//
//  FavoriteFeedCell.swift
//  movie
//
//  Created by Shekhtman Vladyslav on 3/12/18.
//  Copyright © 2018 Shekhtman Vladyslav. All rights reserved.
//

import UIKit

protocol FavoriteCellDelegate {
    func didPressFavoriteCell(sender: Any)
}

class FavoriteFeedCell: BaseCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let favoriteCellId = "favoriteCellId"
    
    var delegate: FavoriteCellDelegate?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var films: [FilmEntity] = []
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.delegate = self
        cv.backgroundColor = .white
        cv.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        cv.scrollIndicatorInsets = UIEdgeInsetsMake(30, 0, 0, 0)
        return cv
    }()
    
    func getMovieData() {
        do {
            films = try context.fetch(FilmEntity.fetchRequest())
        } catch {
            print("Fetching movies failed")
        }
    }
    
    override func setupViews() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData(notification:)), name: Notification.Name("FavoriteTabTapped"), object: nil)
        
        getMovieData()
        collectionView.reloadData()
        
        collectionView.register(FavoriteCell.self, forCellWithReuseIdentifier: favoriteCellId)
        
        addSubview(collectionView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView)
    }
    
    // Mark: CollectionView functions
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: favoriteCellId, for: indexPath) as? FavoriteCell else { return UICollectionViewCell() }
        cell.film = films[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didPressFavoriteCell(sender: films[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return films.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: 200)
    }
    
    // Mark: #Selector handlers
    @objc func reloadData(notification: NSNotification) {
        setupViews()
        print(123)
    }
}
