//
//  CategoryCell.swift
//  MyAppStore
//
//  Created by Armin Spahic on 25/09/2018.
//  Copyright © 2018 Armin Spahic. All rights reserved.
//

import UIKit

class CategoryCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let celId = "cellId"
    var featuredAppsController: FeaturedAppsController?
    var appCategory: AppCategory? {
        didSet {
            if let name = appCategory?.name {
                nameLabel.text = name
            }
            
            appsCollectionView.reloadData()
        }
    }
    
    lazy var appsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white
        cv.register(AppCell.self, forCellWithReuseIdentifier: celId)
        return cv
    }()
    
    let separatorLine: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var nameLabel: UILabel = {
       let label = UILabel()
        label.text = "Best New Apps"
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = appCategory?.apps?.count {
            return count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: celId, for: indexPath) as! AppCell
        cell.app = appCategory?.apps?[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: frame.height - 32)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectedApp = appCategory?.apps?[indexPath.item] {
            featuredAppsController?.showAppDetailForApp(app: selectedApp)
        }
    }
    
    func setupViews() {
        appsCollectionView.dataSource = self
        appsCollectionView.delegate = self
        backgroundColor = .clear
        addSubview(appsCollectionView)
        addSubview(separatorLine)
        addSubview(nameLabel)
        addConstraintsWithFormat(format: "H:|-14-[v0]|", views: nameLabel)
        addConstraintsWithFormat(format: "H:|-14-[v0]|", views: separatorLine)
        addConstraintsWithFormat(format: "H:|[v0]|", views: appsCollectionView)
        addConstraintsWithFormat(format: "V:|[v0(30)][v1][v2(0.5)]|", views: nameLabel, appsCollectionView, separatorLine)
        
}
}


