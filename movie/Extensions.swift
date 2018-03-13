//
//  Extensions.swift
//  movie
//
//  Created by Shekhtman Vladyslav on 2/28/18.
//  Copyright © 2018 Shekhtman Vladyslav. All rights reserved.
//

import UIKit

extension UIViewController {
    func addSubviewsToView(addToView view: UIView, suchSubviews subviews: UIView...) {
        for i in subviews {
            view.addSubview(i)
        }
    }
}

extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}
