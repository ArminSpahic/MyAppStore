//
//  ScreenshotsCell.swift
//  MyAppStore
//
//  Created by Armin Spahic on 02/10/2018.
//  Copyright © 2018 Armin Spahic. All rights reserved.
//

import UIKit

class ScreenshotCell: BaseCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var imageArray: Screenshots? {
        didSet{
            collectionView.reloadData()
        }
    }
    
    let cellID = "cellID"
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
       let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        return cv
    }()
    
    let dividerLineView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        return view
    }()
    
    override func setupViews() {
        super.setupViews()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ScreenshotImageCell.self, forCellWithReuseIdentifier: cellID)
        addSubview(collectionView)
        addSubview(dividerLineView)
        addConstraintsWithFormat(format: "H:|-14-[v0]|", views: dividerLineView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "V:|[v0][v1(1)]|", views: collectionView, dividerLineView)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray?.screenshots?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ScreenshotImageCell
        if let imageName = imageArray?.screenshots?[indexPath.item] {
            cell.screenShot = imageName
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width - 30, height: frame.height - 28)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
    }
    
}

class ScreenshotImageCell: BaseCell {
    
    var screenShot: String? {
        didSet {
            if let imageName = screenShot {
                imageView.image = UIImage(named: imageName)
            }
        }
    }
    
    let imageView: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .green
        return iv
    }()
    
    override func setupViews() {
        super.setupViews()
        addSubview(imageView)
        layer.masksToBounds = true
        addConstraintsWithFormat(format: "H:|[v0]|", views: imageView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: imageView)
    }
}

class AppDetailDescriptionCell: BaseCell {
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        return view
    }()
    
    let textView: UITextView = {
       let tv = UITextView()
        tv.text = "SAMPLE DESCRIPTION"
        return tv
    }()
    
    override func setupViews() {
        super.setupViews()
        addSubview(textView)
        addSubview(dividerLineView)
        addConstraintsWithFormat(format: "H:|-14-[v0]|", views: dividerLineView)
        addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: textView)
        addConstraintsWithFormat(format: "V:|-4-[v0]-4-[v1(1)]|", views: textView, dividerLineView)
        
    }
}

class InformationCell: BaseCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    let detailInfoId = "detailInfoId"
    
    var information: [AppInformation]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: detailInfoId, for: indexPath) as! DetailInfoCell
        if information != nil {
        cell.nameLabel.text = information?[indexPath.item].name
        cell.infoLabel.text = information?[indexPath.item].value
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 20)
    }
    
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
       let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.clear
        return cv
    }()
    
    override func setupViews() {
        super.setupViews()
        addSubview(collectionView)
        collectionView.register(DetailInfoCell.self, forCellWithReuseIdentifier: detailInfoId)
        collectionView.delegate = self
        collectionView.dataSource = self
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView)
    }
}

class DetailInfoCell: BaseCell {
    
    let nameLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = UIColor.lightGray
        label.textAlignment = .right
        return label
    }()
    
    let infoLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        addSubview(nameLabel)
        addSubview(infoLabel)
        addConstraintsWithFormat(format: "H:|-16-[v0(80)]-8-[v1]|", views: nameLabel, infoLabel)
        addConstraintsWithFormat(format: "V:|[v0]|", views: nameLabel)
        addConstraintsWithFormat(format: "V:|[v0]|", views: infoLabel)
    }
}
