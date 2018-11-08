//
//  ViewController.swift
//  MyAppStore
//
//  Created by Armin Spahic on 25/09/2018.
//  Copyright © 2018 Armin Spahic. All rights reserved.
//

import UIKit

class FeaturedAppsController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var featuredApps: [AppCategory]?
    var appCategories: [AppCategory]?
    private let largeCellId = "largeCellId"
    private let categoryCellId = "categoryId"
    private let headerId = "headerId"
    override func viewDidLoad() {
        super.viewDidLoad()
        AppCategory.fetchFeaturedApps { (appCategories, featuredApps) in
            self.featuredApps = featuredApps
            self.appCategories = appCategories
            self.collectionView.reloadData()
        }
        setupCollectionView()
        navigationItem.title = "Featured Apps"
        // Do any additional setup after loading the view, typically from a nib.
        //appCategories = AppCategory.sampleAppCategories()
        
    }
    
    func setupCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: categoryCellId)
        collectionView.register(LargeCategoryCell.self, forCellWithReuseIdentifier: largeCellId)
        collectionView.register(Header.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
    }
    
    func showAppDetailForApp(app: App) {
        let layout = UICollectionViewFlowLayout()
        let detailAppController = DetailsViewController(collectionViewLayout: layout)
        detailAppController.screenApp = app
        navigationController?.pushViewController(detailAppController, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = appCategories?.count {
            return count
        }
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: largeCellId, for: indexPath) as! LargeCategoryCell
            cell.appCategory = appCategories?[indexPath.item]
            cell.featuredAppsController = self
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: categoryCellId, for: indexPath) as! CategoryCell
        cell.appCategory = appCategories?[indexPath.item]
        cell.featuredAppsController = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 2 {
            return CGSize(width: view.frame.width, height: 160)
        } else {
        return CGSize(width: view.frame.width, height: 230)
    }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! Header
        header.appCategory = featuredApps?[indexPath.item]
        header.featuredAppsController = self
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }


}

class Header: CategoryCell {
    
    let bannerCellId = "largeAppCellId"
    
    override func setupViews() {
        
        super.setupViews()
        appsCollectionView.register(BannerCell.self, forCellWithReuseIdentifier: bannerCellId)
        
        
        addSubview(appsCollectionView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: appsCollectionView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: appsCollectionView)
    }
    
    override
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: bannerCellId, for: indexPath) as! BannerCell
        cell.app = appCategory?.apps?[indexPath.item]
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (frame.width / 2) + 50, height: frame.height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectedApp = appCategory?.apps?[indexPath.item] {
            featuredAppsController?.showAppDetailForApp(app: selectedApp)
            let layout = UICollectionViewFlowLayout()
            let detailsController = DetailsViewController(collectionViewLayout: layout)
            detailsController.screenApp = selectedApp
        }
    }
    
    private class BannerCell: AppCell {
        
        override func setupViews() {
            appImageView.translatesAutoresizingMaskIntoConstraints = false
            appImageView.layer.cornerRadius = 0.0
            appImageView.layer.borderWidth = 0.1
            addSubview(appImageView)
            addConstraintsWithFormat(format: "H:|[v0]|", views: appImageView)
            addConstraintsWithFormat(format: "V:|[v0]|", views: appImageView)
        }
        
    }
    
}

class LargeCategoryCell: CategoryCell {
    
    let largeAppCellId = "largeAppCellId"

    override func setupViews() {
        super.setupViews()
        appsCollectionView.register(LargeAppCell.self, forCellWithReuseIdentifier: largeAppCellId)
        
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: largeAppCellId, for: indexPath) as! LargeAppCell
        cell.app = appCategory?.apps?[indexPath.item]
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: frame.height - 32)
    }
    
    private class LargeAppCell: AppCell {

        override func setupViews() {
            appImageView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(appImageView)
            addConstraintsWithFormat(format: "H:|[v0]|", views: appImageView)
            addConstraintsWithFormat(format: "V:|-2-[v0]-14-|", views: appImageView)
        }

    }
    
}






