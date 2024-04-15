//
//  ProductView.swift
//  WishListNBC
//
//  Created by David Jang on 4/12/24.
//

//import UIKit
//
//class ProductView: UIView {
//    
//    private let productImageView = UIImageView()
//    private let idLabel = UILabel()
//    private let titleLabel = UILabel()
//    private let descriptionLabel = UILabel()
//    private let priceLabel = UILabel()
//    
//    var product: Model? {
//        didSet {
//            updateUI()
//        }
//    }
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        //        setupViews()
//        styleLabel()
//    }
//    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        //        setupViews()
//        styleLabel()
//    }
//    
//    //    private func setupViews() {
//    //        addSubview(productImageView)
//    //        addSubview(idLabel)
//    //        addSubview(titleLabel)
//    //        addSubview(descriptionLabel)
//    //        addSubview(priceLabel)
//    //
//    //        productImageView.translatesAutoresizingMaskIntoConstraints = false
//    //        idLabel.translatesAutoresizingMaskIntoConstraints = false
//    //        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//    //        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
//    //        priceLabel.translatesAutoresizingMaskIntoConstraints = false
//    //
//    //        productImageView.contentMode = .scaleAspectFit
//    //    }
//    
////    private func styleLabel() {
////        idLabel.font = UIFont.systemFont(ofSize: 11)
////        titleLabel.font = UIFont.systemFont(ofSize: 16)
////        descriptionLabel.font = UIFont.systemFont(ofSize: 13)
////        priceLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
////        
////        idLabel.textColor = .red
////        titleLabel.textColor = .black
////        descriptionLabel.textColor = .gray
////        priceLabel.textColor = .blue
////    }
//    
//    private func updateUI() {
//        guard let product = product else { return }
//        idLabel.text = "ID: \(product.id)"
//        titleLabel.text = product.title
//        descriptionLabel.text = product.productDescription
//        priceLabel.text = "$\(product.price)"
//        
//    }
//}
