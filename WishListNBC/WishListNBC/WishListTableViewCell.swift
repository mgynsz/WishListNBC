//
//  WishListTableViewCell.swift
//  WishListNBC
//
//  Created by David Jang on 4/15/24.
//

import UIKit

class WishListTableViewCell: UITableViewCell {
    
    static let identifier = "WishListTableViewCell"
    
    var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var quantityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = .orange
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var stepper: UIStepper = {
        let stepper = UIStepper()
        stepper.translatesAutoresizingMaskIntoConstraints = false
        return stepper
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(quantityLabel)
        contentView.addSubview(stepper)
        
        NSLayoutConstraint.activate([
            thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: 60),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 60),
            
            titleLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            
            quantityLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            quantityLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            
            stepper.leadingAnchor.constraint(equalTo: quantityLabel.trailingAnchor, constant: 10),
            stepper.centerYAnchor.constraint(equalTo: quantityLabel.centerYAnchor)
        ])
        
        stepper.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .valueChanged)
    }
    
    @objc private func stepperValueChanged(_ sender: UIStepper) {
        quantityLabel.text = "Qty: \(Int(sender.value))"
        // 필요하다면, 델리게이트나 클로저를 통해 뷰 컨트롤러에 변경을 알릴 수 있습니다.
    }
    
    // UI 생성
    func configure(with product: Product) {
        titleLabel.text = product.title
        quantityLabel.text = "Qty: \(product.quantity)"
        if let thumbnailURL = product.thumbnail, let url = URL(string: thumbnailURL) {
            thumbnailImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
        } else {
            thumbnailImageView.image = UIImage(named: "placeholder")
        }
        stepper.value = Double(product.quantity)
    }
}

