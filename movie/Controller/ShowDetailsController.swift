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
    var selectedMovie = Movie()
    
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
    
    func initMovieData(movieFromCell: Movie) {
        self.selectedMovie = movieFromCell
        setupMovieDataFromSelectedCell()
    }
    
    func initTvShowData(tvShowFromCell: Movie) {
        self.selectedMovie = tvShowFromCell
        setupTvShowDataFromSelectedCell()
    }
    
    func setupTvShowDataFromSelectedCell() {
        name.text = selectedMovie.title
        rating.text = selectedMovie.rating?.description
        overview.text = selectedMovie.overview
        setupTvShowPosterImage()
        setTvShowTitleHeight()
        
        if let releaseYear = selectedMovie.year {
            let releaseYearWithPrefix = String(releaseYear.prefix(4))
            year.text = releaseYearWithPrefix
        }
        
    }
    
    func setupMovieDataFromSelectedCell() {
        name.text = selectedMovie.title
        rating.text = selectedMovie.rating?.description
        overview.text = selectedMovie.overview
        setupMoviePosterImage()
        setMovieTitleHeight()
        
        if let releaseYear = selectedMovie.year {
            let releaseYearWithPrefix = String(releaseYear.prefix(4))
            year.text = releaseYearWithPrefix
        }
    }
    
    func setupTvShowPosterImage() {
        if let posterImageUrl = selectedMovie.posterName {
            guard let url = URL(string: posterImageUrl) else { return }
            
            if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
                self.posterImageView.image = imageFromCache
                return
            }
        }
    }
    
    func setupMoviePosterImage() {
        if let posterImageUrl = selectedMovie.posterName {
            guard let url = URL(string: posterImageUrl) else { return }
            
            if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
                self.posterImageView.image = imageFromCache
                return
            }
        }
    }
    
    func setTvShowTitleHeight() {
        if let title = selectedMovie.title {
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
    
    func setMovieTitleHeight() {
        if let title = selectedMovie.title {
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
            // saving selectedMovie to core data
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let movieEntity = FilmEntity(context: context)
            movieEntity.overview = selectedMovie.overview
            movieEntity.posterName = selectedMovie.posterName
            movieEntity.rating = selectedMovie.rating!
            movieEntity.title = selectedMovie.title
            movieEntity.year = selectedMovie.year
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            print("saved movie to core data")
    }
    
    @objc func backButtonTapped() {
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
}
