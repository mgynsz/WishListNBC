//
//  ProductCollectionViewCell.swift
//  WishListNBC
//
//  Created by David Jang on 4/9/24.
//

import UIKit
import SDWebImage

class ProductCollectionViewCell: UICollectionViewCell {
    
    // 셀 사용 식별자 선언
    static let identifier = "ProductCollectionViewCell"
    
    private let productImageView = UIImageView()   // 제품 이미지
    private let idLabel = UILabel()   // 제품 id
    private let titleLabel = UILabel()   // 제품명
    private let descriptionLabel = UILabel()   // 제품 설명
    private let priceLabel = UILabel()   // 제품 가격
    
    // 셀 생성자
    override init(frame: CGRect) {
        super.init(frame: frame)
        showCollectionView()
    }
    
    // 스토리보드, Xib 로드를 막는 초기화 선언
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 셀 구성
    private func showCollectionView() {        
        productImageView.contentMode = .scaleAspectFit
        //        productImageView.clipsToBounds = true  // 이미지를 Fill로 설정 할 경우 필요 없으면 경계를 넘을 수 있음
        
        // 셀 텍스트 관련 설정
        idLabel.font = UIFont.systemFont(ofSize: 11)
        idLabel.textColor = .red
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textColor = .gray
        descriptionLabel.numberOfLines = 0
        priceLabel.font = UIFont.systemFont(ofSize: 16)
        priceLabel.textColor = .blue
        
        setupCollectionView()
    }
    
    // 레이블 오토레이아웃 설정
    private func setupCollectionView() {
        
        contentView.addSubview(productImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(idLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(priceLabel)
        // 오토레이아웃 설정 전 시스템 자동 위치 변경 비활성
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        idLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            productImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            productImageView.heightAnchor.constraint(equalToConstant: 300),
            titleLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: productImageView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
            titleLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 32),
            
            idLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 16),
            idLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            descriptionLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 84),
            
            priceLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            priceLabel.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            //            priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            priceLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 32),
        ])
    }
    
    // 셀 UI 업데이트
    func configure(with model: Model) {
        titleLabel.text = model.title
        idLabel.text = "ID: \(String(model.id))"
        descriptionLabel.text = model.productDescription
        priceLabel.text = "$\(model.price.formattedWithSeparator)"
        
        // SDWWebImage 비동기적으로 이미지
        if let urlString = model.thumbnail, let url = URL(string: urlString) {
            productImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
        } else {
            productImageView.image = UIImage(named: "placeholder")
        }
    }
}


