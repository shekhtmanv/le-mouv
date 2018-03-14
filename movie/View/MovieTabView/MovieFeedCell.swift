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
    var fetchedFilms: [FilmEntity] = []
    
    var delegate: FilmCellDelegate?
    var films: [Film]?
    let cellId = "cellId"
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.delegate = self
        cv.dataSource = self
        cv.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        cv.scrollIndicatorInsets = UIEdgeInsetsMake(30, 0, 0, 0)
        return cv
    }()
    
    override func setupViews() {
        super.setupViews()

        NotificationCenter.default.addObserver(self, selector: #selector(fetchMovies), name: NSNotification.Name("SearchMovies"), object: nil)
        
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: cellId)
        
        addSubview(collectionView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView)
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
    
    // Mark: Functions
    func getMovieData() {
        do {
            fetchedFilms = try context.fetch(FilmEntity.fetchRequest())
        } catch {
            print("Fetching movies failed")
        }
    }
    
    // Mark: Selector handlers
    @objc func addToFavoriteBtnPressed(sender: UIButton) {
        guard let cell = sender.superview as? UICollectionViewCell else { return }
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        
        let film = films![indexPath.item]
        
        // save selected film to core data
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let filmEntity = FilmEntity(context: context)
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
        guard let searchQuery = notification.userInfo?["searchQuery"] as? String else { return }
        
        ApiService.sharedInstance.retrieveMoviesJson(searchQuery: searchQuery) { (films: [Film]) in
            self.films = films
            self.collectionView.reloadData()
        }
    }
    
}
