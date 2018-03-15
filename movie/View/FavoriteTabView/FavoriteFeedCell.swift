//
//  FavoriteFeedCell.swift
//  movie
//
//  Created by Shekhtman Vladyslav on 3/12/18.
//  Copyright © 2018 Shekhtman Vladyslav. All rights reserved.
//

import UIKit

protocol FavoriteFeedCellDelegate {
    func didPressFavoriteCell(sender: Any)
}

class FavoriteFeedCell: BaseCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var delegate: FavoriteFeedCellDelegate?
    let favoriteCellId = "favoriteCellId"
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var films: [FilmEntity] = []
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsVerticalScrollIndicator = false
        cv.dataSource = self
        cv.delegate = self
        cv.backgroundColor = .white
        return cv
    }()
    
    func getFilmData() {
        do {
            films = try context.fetch(FilmEntity.fetchRequest())
        } catch {
            print("Fetching movies failed")
        }
    }
    
    override func setupViews() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData(notification:)), name: Notification.Name("FavoriteTabTapped"), object: nil)
        
        getFilmData()
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
        cell.deleteButton.isUserInteractionEnabled = true
        cell.deleteButton.addTarget(self, action: #selector(deleteBtnPressed(sender:)), for: .touchUpInside)
        cell.deleteButton.tag = indexPath.item
        
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
    @objc func deleteBtnPressed(sender: UIButton) {
        guard let cell = sender.superview as? UICollectionViewCell else { return }
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        
        let film = films[indexPath.item]

        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        context.delete(film)

        do {
            try context.save()
        } catch {
            print(error)
        }
        
        setupViews()
    }
    
    @objc func reloadData(notification: NSNotification) {
        setupViews()
    }
}
