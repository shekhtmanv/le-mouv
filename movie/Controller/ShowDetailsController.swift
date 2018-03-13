//
//  ShowDetailsController.swift
//  movie
//
//  Created by Shekhtman Vladyslav on 3/6/18.
//  Copyright © 2018 Shekhtman Vladyslav. All rights reserved.
//

import UIKit

class ShowDetailsController: UIViewController, UIGestureRecognizerDelegate {
    
    // Mark: Constants, variables
    var nameHeightConstraint: NSLayoutConstraint?
    var selectedFilm = Film()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        settingCustomBackButton()
        setupViews()
        addSwipe()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.hidesBarsOnSwipe = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // Mark: Views, buttons, labels
    let addToFavoriteButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.rgb(red: 248, green: 93, blue: 94)
        btn.setImage(UIImage(named: "favorite"), for: .normal)
        btn.setTitle("Add to", for: .normal)
        btn.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 17)
        btn.semanticContentAttribute = .forceRightToLeft
        btn.imageView?.contentMode = .scaleAspectFit
        btn.layer.cornerRadius = 4
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(addToFavorite), for: .touchUpInside)
        return btn
    }()

    let overview: UITextView = {
        let txtView = UITextView()
        txtView.font = UIFont(name: "Helvetica", size: 17)
        txtView.backgroundColor = .clear
        txtView.textAlignment = .center
        txtView.isScrollEnabled = true
        txtView.isEditable = false
        txtView.isSelectable = false
        return txtView
    }()
    
    let year: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica", size: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let rating: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica", size: 17)
        return label
    }()
    
    let movieYearLbl: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica-Bold", size: 17)
        label.text = "Year:"
        return label
    }()
    
    let movieRatingLbl: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica-Bold", size: 17)
        label.text = "Rating:"
        return label
    }()
    
    let name: UILabel = {
        let name = UILabel()
        name.font = UIFont(name: "Helvetica-Bold", size: 18)
        name.numberOfLines = 2
        return name
    }()
    
    let posterImageView: UIImageView = {
        let imgView = UIImageView()
        return imgView
    }()
    
    // Mark: Fuctions
    func addSwipe() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(backButtonTapped))
        swipeLeft.direction = .right
        swipeLeft.delegate = self
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func initData(filmFromCell: Film) {
        self.selectedFilm = filmFromCell
        setupMovieDataFromSelectedCell()
    }

    func setupMovieDataFromSelectedCell() {
        name.text = selectedFilm.title
        rating.text = selectedFilm.rating?.description
        overview.text = selectedFilm.overview
        setupPosterImage()
        setTitleHeight()
        
        if let releaseYear = selectedFilm.year {
            let releaseYearWithPrefix = String(releaseYear.prefix(4))
            year.text = releaseYearWithPrefix
        }
    }
    
    func setupPosterImage() {
        if let posterImageUrl = selectedFilm.posterName {
            guard let url = URL(string: posterImageUrl) else { return }
            
            if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
                self.posterImageView.image = imageFromCache
                return
            }
        }
    }
    
    func setTitleHeight() {
        if let title = selectedFilm.title {
            let size = CGSize(width: view.frame.width - 130, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedRect = NSString(string: title).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 19)], context: nil)
            
            if estimatedRect.size.height > 30 {
                nameHeightConstraint?.constant = 50
            } else {
                nameHeightConstraint?.constant = 30
            }
            
        }
    }
    
    func setupViews() {
        addSubviewsToView(addToView: self.view, suchSubviews: posterImageView, name, movieRatingLbl, movieYearLbl, rating, year, overview, addToFavoriteButton)
        
        view.addConstraintsWithFormat(format: "V:|-20-[v0]-7-[v1(30)]-6-[v2(30)]-6-[v3(30)]", views: name, movieRatingLbl, movieYearLbl, addToFavoriteButton)
        view.addConstraintsWithFormat(format: "V:|-20-[v0(160)]-20-[v1]-20-|", views: posterImageView, overview)
        view.addConstraintsWithFormat(format: "H:|-10-[v0(100)]-20-[v1]-10-|", views: posterImageView, name)
        view.addConstraintsWithFormat(format: "V:[v0(40)]", views: rating)
        view.addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: overview)
        view.addConstraintsWithFormat(format: "H:[v0(112)]", views: addToFavoriteButton)
        
        nameHeightConstraint = name.heightAnchor.constraint(equalToConstant: 30)
        nameHeightConstraint?.isActive = true
        
        view.addConstraint(NSLayoutConstraint(item: movieRatingLbl, attribute: .left, relatedBy: .equal, toItem: name, attribute: .left, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: movieYearLbl, attribute: .left, relatedBy: .equal, toItem: name, attribute: .left, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: rating, attribute: .left, relatedBy: .equal, toItem: movieRatingLbl, attribute: .right, multiplier: 1, constant: 10))
        view.addConstraint(NSLayoutConstraint(item: rating, attribute: .centerY, relatedBy: .equal, toItem: movieRatingLbl, attribute: .centerY, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: year, attribute: .left, relatedBy: .equal, toItem: movieYearLbl, attribute: .right, multiplier: 1, constant: 10))
        view.addConstraint(NSLayoutConstraint(item: year, attribute: .centerY, relatedBy: .equal, toItem: movieYearLbl, attribute: .centerY, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: addToFavoriteButton, attribute: .left, relatedBy: .equal, toItem: movieYearLbl, attribute: .left, multiplier: 1, constant: 0))
    }
    
    func settingCustomBackButton() {
        let customButton = UIBarButtonItem(image: UIImage(named: "backWhite")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem  = customButton
    }
    
    // Mark: #Selector handlers
    @objc func addToFavorite() {
        // saving selectedFilm to core data
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let filmEntity = FilmEntity(context: context)
        filmEntity.overview = selectedFilm.overview
        filmEntity.posterName = selectedFilm.posterName
        filmEntity.rating = selectedFilm.rating!
        filmEntity.title = selectedFilm.title
        filmEntity.year = selectedFilm.year
        filmEntity.type = selectedFilm.type
            
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        print("saved film to core data")
    }
    
    @objc func backButtonTapped() {
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
}
