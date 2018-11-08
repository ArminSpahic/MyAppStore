//
//  AppCell.swift
//  MyAppStore
//
//  Created by Armin Spahic on 25/09/2018.
//  Copyright © 2018 Armin Spahic. All rights reserved.
//

import UIKit

class AppCell: UICollectionViewCell {
    
    var app: App? {
        didSet {
            if let name = app?.name {
                appLabel.text = name
                let rect = NSString(string: name).boundingRect(with: CGSize(width: frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], context: nil)
                
                if rect.height > 20 {
                    categoryLabel.frame = CGRect(x: 0, y: frame.width + 32, width: frame.width, height: 20)
                    priceLabel.frame = CGRect(x: 0, y: frame.width + 48, width: frame.width, height: 20)
                } else {
                    categoryLabel.frame = CGRect(x: 0, y: frame.width + 18, width: frame.width, height: 20)
                    priceLabel.frame = CGRect(x: 0, y: frame.width + 34, width: frame.width, height: 20)
                }
                appLabel.frame = CGRect(x: 0, y: frame.width + 5, width: frame.width, height: 40)
                appLabel.sizeToFit()
            }
            categoryLabel.text = app?.category
            if let price = app?.price {
                priceLabel.text = "$\(price)"
            } else {
                priceLabel.text = ""
            }
            if let imageName = app?.imageName {
                appImageView.image = UIImage(named: imageName)
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let appImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.backgroundColor = .blue
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.image = UIImage()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let appLabel: UILabel = {
       let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 2
        return label
    }()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        return label
        
    }()
    
    let priceLabel: UILabel = {
       let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.lightGray
        return label
    }()
    
    func setupViews() {
        addSubview(appImageView)
        addSubview(appLabel)
        addSubview(categoryLabel)
        addSubview(priceLabel)
//        addConstraintsWithFormat(format: "H:|[v0(\(frame.width))]|", views: appImageView)
//        addConstraintsWithFormat(format: "V:|[v0(\(frame.width))]|", views: appImageView)
        appImageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.width)
       
        
    }
}
