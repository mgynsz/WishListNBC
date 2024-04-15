//
//  WishListTableViewCell.swift
//  WishListNBC
//
//  Created by David Jang on 4/15/24.
//

//import UIKit
//
//class WishListTableViewCell: UITableViewCell {
//    static let identifier = "WishListTableViewCell"
//    
//    let thumbnailImageView = UIImageView()
//    let titleLabel = UILabel()
//    let quantityLabel = UILabel()
//    let stepper = UIStepper()
//    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setupViews()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func setupViews() {
//        selectionStyle = .none
//        clipsToBounds = true
//        
//        addSubview(thumbnailImageView)
//        addSubview(titleLabel)
//        addSubview(quantityLabel)
//        addSubview(stepper)
//        
//        // Setup constraints and additional configuration here
//        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        quantityLabel.translatesAutoresizingMaskIntoConstraints = false
//        stepper.translatesAutoresizingMaskIntoConstraints = false
//        
//        // Add constraints and setup code
//        setupConstraints()
//    }
//    
//    private func setupConstraints() {
//        // Example constraints
//        NSLayoutConstraint.activate([
//            thumbnailImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
//            thumbnailImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
//            thumbnailImageView.widthAnchor.constraint(equalToConstant: 60),
//            thumbnailImageView.heightAnchor.constraint(equalToConstant: 60),
//            
//            titleLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 10),
//            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
//            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
//            
//            quantityLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 10),
//            quantityLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
//            
//            stepper.leadingAnchor.constraint(equalTo: quantityLabel.trailingAnchor, constant: 10),
//            stepper.centerYAnchor.constraint(equalTo: centerYAnchor)
//        ])
//    }
//}
//
