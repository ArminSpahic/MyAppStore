//
//  DetailsViewController.swift
//  MyAppStore
//
//  Created by Armin Spahic on 02/10/2018.
//  Copyright © 2018 Armin Spahic. All rights reserved.
//

import UIKit

class DetailsViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var imagesArray = Screenshots()
    var screenApp: App? {
        didSet{
            //to check when its not nil to continue
            if imagesArray.screenshots != nil {
                return
            }
            if let id = screenApp?.id {
                DetailedAppPresent.fetchDetailedAppById(id: id.intValue) { (imagesArray) in
                    self.imagesArray = imagesArray
                    self.collectionView.reloadData()
                }
            }
        }
    }
    private let cellId = "cellId"
    private let headerId = "headerId"
    private let descCellId = "descCellId"
    private let infoCellId = "infoCellId"
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
       collectionView.register(DetailsViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.register(ScreenshotCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(AppDetailDescriptionCell.self, forCellWithReuseIdentifier: descCellId)
        collectionView.register(InformationCell.self, forCellWithReuseIdentifier: infoCellId)
        collectionView.alwaysBounceVertical = true
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: descCellId, for: indexPath) as! AppDetailDescriptionCell
            cell.textView.attributedText = descriptionAttributeText()
            return cell
        } else if indexPath.item == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: infoCellId, for: indexPath) as! InformationCell
            if imagesArray != nil {
            cell.information = imagesArray.appInformation
            }
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ScreenshotCell
        if imagesArray != nil {
            cell.imageArray = imagesArray
        }
        return cell
    }
    
    private func descriptionAttributeText() -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: "Description\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)])
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 10
        let range = NSRange(location: 0, length: attributedText.string.count)
        attributedText.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: range)
        if let desc = imagesArray.desc {
            attributedText.append(NSAttributedString(string: desc, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11), NSAttributedString.Key.foregroundColor: UIColor.darkGray]))
        }
        return attributedText
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 1 {
            let dummySize = CGSize(width: view.frame.width - 8 - 8, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin)
            let rect = descriptionAttributeText().boundingRect(with: dummySize, options: options, context: nil)
            
            return CGSize(width: view.frame.width, height: rect.height + 30)
        }
        
        return CGSize(width: view.frame.width, height: 200)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! DetailsViewHeader
        header.app = screenApp
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
       return CGSize(width: view.frame.width, height: 170)
    }
    
}

class DetailsViewHeader: BaseCell {
    
    var app: App? {
        didSet{
        if let imageName = UIImage(named: app?.imageName ?? "") {
            imageView.image = imageName
            nameLabel.text = app?.name
        }
            if let price = app?.price?.stringValue {
                buyButton.setTitle("$\(price)", for: .normal)
            }
        }
    }
    
    let imageView: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 16.0
        iv.layer.masksToBounds = true
        return iv
    }()
    
    let segmentedControl: UISegmentedControl = {
       let sc = UISegmentedControl(items: ["Details", "Reviews", "Related"])
        sc.tintColor = UIColor.darkGray
        sc.selectedSegmentIndex = 0
        return sc
    }()
    
    let nameLabel: UILabel = {
       let nl = UILabel()
        nl.text = "TEST"
        nl.numberOfLines = 2
        nl.translatesAutoresizingMaskIntoConstraints = false
        nl.font = UIFont.systemFont(ofSize: 16)
        nl.lineBreakMode = .byWordWrapping
        return nl
    }()
    
    let buyButton: UIButton = {
       let btn = UIButton(type: .system)
        btn.setTitle("BUY", for: .normal)
        btn.layer.borderColor = UIColor(red: 0, green: 129/255, blue: 250/255, alpha: 1).cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 5.0
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return btn
    }()
    
    let dividerLineView: UIView = {
       let dl = UIView()
        dl.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        return dl
    }()
    
    override func setupViews() {
        super.setupViews()
        imageView.backgroundColor = .green
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        addSubview(segmentedControl)
        addSubview(nameLabel)
        addSubview(buyButton)
        addSubview(dividerLineView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: dividerLineView)
        addConstraintsWithFormat(format: "H:|-14-[v0(100)]-8-[v1]|", views: imageView, nameLabel)
        addConstraintsWithFormat(format: "H:|-40-[v0]-40-|", views: segmentedControl)
        addConstraintsWithFormat(format: "H:[v0(60)]-20-|", views: buyButton)
        addConstraintsWithFormat(format: "V:|-14-[v0(100)]-8-[v1(34)]-12-[v2(0.5)]", views: imageView, segmentedControl, dividerLineView)
        addConstraintsWithFormat(format: "V:|-14-[v0(30)]|", views: nameLabel)
        addConstraintsWithFormat(format: "V:|-80-[v0(32)]|", views: buyButton)
        
        
        
    }
}

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
    }
}
