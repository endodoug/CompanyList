//
//  CompanyCell.swift
//  CompanyList
//
//  Created by doug harper on 11/2/17.
//  Copyright © 2017 Doug Harper. All rights reserved.
//

import UIKit

class CompanyCell: UITableViewCell {
  
  var company: Company? {
    didSet {
      nameFoundedDateLabel.text = company?.name
      
      if let imageData = company?.imageData {
        companyImageView.image = UIImage(data: imageData)
      }
    }
  }
  
  let companyImageView: UIImageView = {
    let imageView = UIImageView(image: #imageLiteral(resourceName: "select_photo_empty"))
    imageView.contentMode = .scaleAspectFill
    imageView.layer.cornerRadius = 20
    imageView.clipsToBounds = true
    imageView.layer.borderColor = ThemeColor.asphalt.cgColor
    imageView.layer.borderWidth = 2
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  let nameFoundedDateLabel: UILabel = {
    let label = UILabel()
    label.text = "Company Name"
    label.font = UIFont.boldSystemFont(ofSize: 16)
    label.textColor = .white
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    backgroundColor = ThemeColor.gray
    
    addSubview(companyImageView)
    companyImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
    companyImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    
    addSubview(nameFoundedDateLabel)
    nameFoundedDateLabel.anchor(top: topAnchor, left: companyImageView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    nameFoundedDateLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
