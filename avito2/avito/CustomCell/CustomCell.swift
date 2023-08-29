//
//  CustomCell.swift
//  avito
//
//  Created by Александра Угольнова on 27.08.2023.
//

import Foundation
import UIKit
import SnapKit

class CustomCell: UICollectionViewCell{
    
     lazy var labelTitle : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Constants.Colors.Title
        label.font = Constants.Fonts.ui16Reg
        return label
    }()
     lazy var labelPrice : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Constants.Colors.Title
        label.font = Constants.Fonts.ui16Bold
        return label
    }()
    lazy var labelLocation : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Constants.Colors.greyDark
        label.font = Constants.Fonts.ui14Regular
        return label
    }()
     lazy var labelTime : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Constants.Colors.greyDark
        label.font = Constants.Fonts.ui12Light
        return label
    }()
    
     lazy var dogImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = Constants.Colors.greyLight
        return imageView
    }()
    
 //   let dogImageView = UIImageView()
    
    override init(frame: CGRect){
        super.init(frame: frame)
     
        setupViews()
        
        dogImageView.layer.cornerRadius = 10
        dogImageView.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    override func prepareForReuse() {
        dogImageView.image = nil
    }
    

    
    func setupViews(){
        
        contentView.addSubview(dogImageView)
        contentView.addSubview(labelTitle)
        contentView.addSubview(labelPrice)
        contentView.addSubview(labelLocation)
        contentView.addSubview(labelTime)
        
            NSLayoutConstraint.activate([
                dogImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
                dogImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                dogImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                dogImageView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
                        
                labelTitle.topAnchor.constraint(equalTo: dogImageView.bottomAnchor, constant: 5),
                labelTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
                labelTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
                        
                labelPrice.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 2),
                labelPrice.leadingAnchor.constraint(equalTo: labelTitle.leadingAnchor),
                        
                labelLocation.topAnchor.constraint(equalTo: labelPrice.bottomAnchor, constant: 4),
                labelLocation.leadingAnchor.constraint(equalTo: labelTitle.leadingAnchor),
                        
                labelTime.topAnchor.constraint(equalTo: labelLocation.bottomAnchor, constant: 4),
                labelTime.leadingAnchor.constraint(equalTo: labelTitle.leadingAnchor),
              //  labelTime.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
                    ])

    }
    
   
}
