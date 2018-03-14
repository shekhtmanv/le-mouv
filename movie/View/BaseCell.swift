//
//  BaseCell.swift
//  movie
//
//  Created by Shekhtman Vladyslav on 3/6/18.
//  Copyright © 2018 Shekhtman Vladyslav. All rights reserved.
//

import UIKit

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        
    }
    
    func addSubviewsToView(addToView view: UIView, SuchSubViews views: UIView...) {
        for i in views {
            view.addSubview(i)
        }
    }
    
    func addSubviewsToCellView(suchSubViews views: UIView...) {
        for i in views {
            addSubview(i)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
