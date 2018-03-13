//
//  FavoriteCell.swift
//  movie
//
//  Created by Shekhtman Vladyslav on 3/12/18.
//  Copyright © 2018 Shekhtman Vladyslav. All rights reserved.
//

import UIKit

class FavoriteCell: BaseCell {
    
    var nameHeightConstraint: NSLayoutConstraint?
    
    // Mark: Setting cell with data here
    var movie: FilmEntity? {
        didSet {
            name.text = movie?.title
            rating.text = movie?.rating.description
            setupMoviePosterImage()
            setMovieTitleHeight()
            if let releaseYear = movie?.year {
                let releaseYearWithPrefix = String(releaseYear.prefix(4))
                year.text = releaseYearWithPrefix
            }
        }
    }
    
    // Mark: Views, labels, buttons...
    let seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        return view
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
    
    let moviePosterImgView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .darkGray
        return imageView
    }()
    
    func setMovieTitleHeight() {
        // measure title text height
        if let title = movie?.title {
            let size = CGSize(width: frame.width - 130, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedRect = NSString(string: title).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 19)], context: nil)

            if estimatedRect.size.height > 30 {
                nameHeightConstraint?.constant = 50
            } else {
                nameHeightConstraint?.constant = 30
            }
        }
    }
    
    func setupMoviePosterImage() {
        if let posterImageUrl = movie?.posterName {
            guard let url = URL(string: posterImageUrl) else { return }

            if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
                self.moviePosterImgView.image = imageFromCache
                return
            }

            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }

                DispatchQueue.main.async {
                    let imageToCache = UIImage(data: data!)
                    imageCache.setObject(imageToCache!, forKey: url as AnyObject)
                    self.moviePosterImgView.image = imageToCache
                }
            }).resume()
        }
    }
    
    override func setupViews() {
        addSubviewsToCellView(suchSubViews: moviePosterImgView, name, movieRatingLbl, movieYearLbl, rating, year, seperatorView)
        
        addConstraintsWithFormat(format: "V:|-20-[v0]-7-[v1(30)]-6-[v2(30)]", views: name, movieRatingLbl, movieYearLbl)
        addConstraintsWithFormat(format: "V:|-20-[v0]-20-|", views: moviePosterImgView)
        addConstraintsWithFormat(format: "H:|-10-[v0(100)]-20-[v1]-10-|", views: moviePosterImgView, name)
        addConstraintsWithFormat(format: "V:[v0(30)]", views: rating)
        addConstraintsWithFormat(format: "V:[v0(1)]|", views: seperatorView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: seperatorView)
        
        nameHeightConstraint = name.heightAnchor.constraint(equalToConstant: 30)
        nameHeightConstraint?.isActive = true
        
        addConstraint(NSLayoutConstraint(item: movieRatingLbl, attribute: .left, relatedBy: .equal, toItem: name, attribute: .left, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: movieYearLbl, attribute: .left, relatedBy: .equal, toItem: name, attribute: .left, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: rating, attribute: .left, relatedBy: .equal, toItem: movieRatingLbl, attribute: .right, multiplier: 1, constant: 10))
        addConstraint(NSLayoutConstraint(item: rating, attribute: .centerY, relatedBy: .equal, toItem: movieRatingLbl, attribute: .centerY, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: year, attribute: .left, relatedBy: .equal, toItem: movieYearLbl, attribute: .right, multiplier: 1, constant: 10))
        addConstraint(NSLayoutConstraint(item: year, attribute: .centerY, relatedBy: .equal, toItem: movieYearLbl, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
}
