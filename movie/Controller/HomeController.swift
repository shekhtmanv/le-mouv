//
//  ViewController.swift
//  movie
//
//  Created by Shekhtman Vladyslav on 2/28/18.
//  Copyright © 2018 Shekhtman Vladyslav. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, FilmCellDelegate, FavoriteCellDelegate {

    let showDetailsViewController = ShowDetailsController()
    var searchView: UIView?
    var textField: UITextField?
    let cellId = "cellId"
    let tvShowsCellId = "tvShowsCellId"
    let favoriteFeedCellId = "favoriteFeedCellId"
    var trackedTab = 0
    
    lazy var menuBar: MenuBar = {
        let mb = MenuBar()
        mb.homeController = self
        return mb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField?.delegate = self
        navigationController?.navigationBar.isTranslucent = false

        setupCollectionView()
        settingTitleLabel()
        setupMenuBar()
        setupNavBarButtons()
    }
    
    func setupCollectionView() {
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
        }
        
        collectionView?.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        collectionView?.isPagingEnabled = true
        collectionView?.backgroundColor = .white
        collectionView?.register(MovieFeedCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(TVFeedCell.self, forCellWithReuseIdentifier: tvShowsCellId)
        collectionView?.register(FavoriteFeedCell.self, forCellWithReuseIdentifier: favoriteFeedCellId)
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexPath = IndexPath(item: Int(index), section: 0)

        trackedTab = Int(index)
        if trackedTab == 2 {
            NotificationCenter.default.post(name: Notification.Name("FavoriteTabTapped"), object: nil)
        }
        
        menuBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuBar.horizontalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x / 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height - 60)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? MovieFeedCell else {
                print("have problems when dequeuing MovieFeedCell")
                return UICollectionViewCell()
            }
            cell.delegate = self
            return cell
            
        } else if indexPath.item == 1 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tvShowsCellId, for: indexPath) as? TVFeedCell else {
                print("have problems when dequeuing TVFeedCell")
                return UICollectionViewCell()
            }
            cell.delegate = self
            return cell
        }
        
        // otherwise show third cell as FavoriteFeedCell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: favoriteFeedCellId, for: indexPath) as! FavoriteFeedCell
        cell.delegate = self
        return cell
    }
    
    // Mark: Functions
    func didPressFavoriteCell(sender: Any) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        context.delete(sender as! NSManagedObject)
        do {
            try context.save()
        } catch {
            print(error)
        }
        
    }
    
    func didPressCell(sender: Any) {
        showDetailsViewController.initData(filmFromCell: sender as! Film)
        self.searchView?.removeFromSuperview()
        self.navigationController?.pushViewController(showDetailsViewController, animated: true)
    }
    
    func scrollToMenuIndex(menuIndex: Int) {
        let indexPath = IndexPath(item: menuIndex, section: 0)
        collectionView?.scrollToItem(at: indexPath, at: [], animated: true)
    }
    
    private func setupNavBarButtons() {
        let searchImage = UIImage(named: "search")?.withRenderingMode(.alwaysOriginal)
        let searchBarButtonItem = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(handleSearch))
        
        let moreBtn = UIBarButtonItem(image: UIImage(named: "more")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMore))
        
        navigationItem.rightBarButtonItems = [moreBtn, searchBarButtonItem]
    }
    
    func addSearchView() {
        searchView = UIView()
        searchView?.backgroundColor = .white
        
        textField = UITextField()
        textField?.placeholder = "Jot down to search"
        textField?.autocorrectionType = .no
        
        let backBtn: UIButton = {
            let btn = UIButton()
            let btnImage = UIImage(named: "back")
            btn.setImage(btnImage, for: .normal)
            btn.addTarget(self, action: #selector(backBtnWasPressed), for: .touchUpInside)
            return btn
        }()
        
        let searchBtn: UIButton = {
            let btn = UIButton()
            btn.backgroundColor = UIColor.rgb(red: 255, green: 194, blue: 194)
            btn.setTitle("Search", for: .normal)
            btn.addTarget(self, action: #selector(searchBtnWasTapped), for: .touchUpInside)
            btn.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 17)
            return btn
        }()
        
        guard let navigationBarHeight = self.navigationController?.navigationBar.bounds.size.height else { return }
        let screenWidth = UIScreen.main.bounds.width
        
        searchView?.frame = CGRect(x: 0, y: 0, width: screenWidth, height: navigationBarHeight)
        self.navigationController?.navigationBar.addSubview(searchView!)
        addSubviewsToView(addToView: searchView!, suchSubviews: textField!, backBtn, searchBtn)
        
        searchView?.addConstraintsWithFormat(format: "V:|[v0]|", views: searchBtn)
        searchView?.addConstraintsWithFormat(format: "V:|[v0]|", views: backBtn)
        searchView?.addConstraintsWithFormat(format: "V:|[v0]|", views: textField!)
        searchView?.addConstraintsWithFormat(format: "H:|-5-[v0(30)]-5-[v1]-[v2(60)]|", views: backBtn, textField!, searchBtn)
    }
    
    private func setupMenuBar() {
        navigationController?.hidesBarsOnSwipe = true
        
        let redView = UIView()
        redView.backgroundColor = UIColor.rgb(red: 248, green: 93, blue: 94)
        addSubviewsToView(addToView: self.view, suchSubviews: redView, menuBar)
        
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: redView)
        view.addConstraintsWithFormat(format: "V:[v0(60)]", views: redView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: menuBar)
        view.addConstraintsWithFormat(format: "V:[v0(60)]", views: menuBar)
        
        let guide = view.safeAreaLayoutGuide
        menuBar.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.hidesBarsOnSwipe = true
    }
    
    func settingTitleLabel() {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        titleLabel.text = " Le Mouv"
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "Bradley Hand", size: 25)
        navigationItem.titleView = titleLabel
    }
    
    func addingSubviewsToView(addToView view: UIView, suchSubviews subviews: UIView...) {
        for i in subviews {
            view.addSubview(i)
        }
    }
    
    // Mark: #selector handlers
    @objc func handleSearch() {
        addSearchView()
    }
    
    @objc func searchBtnWasTapped() {
        
        // creating and posting notification with searchQuery
        guard let searchQuery = textField?.text else { return }
        let searchQueryDict: [String : String] = ["searchQuery" : searchQuery]

        if trackedTab == 0 {
            NotificationCenter.default.post(name: Notification.Name("SearchMovies"), object: nil, userInfo: searchQueryDict)
        } else if trackedTab == 1 {
            NotificationCenter.default.post(name: Notification.Name("SearchTvShows"), object: nil, userInfo: searchQueryDict)
        }
        
        self.searchView?.removeFromSuperview()
    }
    
    @objc func backBtnWasPressed() {
        self.searchView?.removeFromSuperview()
    }
    
    @objc func handleMore() {
        
    }
}

