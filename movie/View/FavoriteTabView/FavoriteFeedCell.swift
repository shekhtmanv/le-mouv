//
//  FavoriteFeedCell.swift
//  movie
//
//  Created by Shekhtman Vladyslav on 3/12/18.
//  Copyright © 2018 Shekhtman Vladyslav. All rights reserved.
//

import UIKit

class FavoriteFeedCell: BaseCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let favoriteCellId = "favoriteCellId"
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var movies: [FilmEntity] = []
    
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
            movies = try context.fetch(FilmEntity.fetchRequest())
        } catch {
            print("Fetching movies failed")
        }
    }
    
    override func setupViews() {
        getMovieData()
        
        collectionView.register(FavoriteCell.self, forCellWithReuseIdentifier: favoriteCellId)
        
        addSubview(collectionView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView)
    }
    
    // Mark: CollectionView functions
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: favoriteCellId, for: indexPath) as? FavoriteCell else { return UICollectionViewCell() }
        cell.movie = movies[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: 200)
    }
    
}
