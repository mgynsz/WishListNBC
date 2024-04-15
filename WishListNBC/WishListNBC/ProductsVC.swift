//
//  ProductCollectionVC.swift
//  WishListNBC
//
//  Created by David Jang on 4/9/24.
//

import UIKit

class ProductsVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var products: [Model] = []   // 제품 데이터 배열 생성
    var collectionView: UICollectionView!   // 컬렉션뷰 선언
    var onProductSelected: ((Model) -> Void)?   // 콜백 함수
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewLayout()

    }
    
    // 컬렉션 뷰 설정
    private func collectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: view.bounds.width, height: view.bounds.height - 100)
        layout.minimumLineSpacing = 0
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: ProductCollectionViewCell.identifier)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.layer.borderWidth = 1
        collectionView.layer.borderColor = UIColor.black.cgColor
        collectionView.clipsToBounds = true
        
        view.addSubview(collectionView)
        
        // 컬렉션 뷰 오토레이아웃
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    // 컬렉션 뷰 아이템 수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    // 컬렉션 뷰 셀 구성
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.identifier, for: indexPath) as? ProductCollectionViewCell else {
            fatalError("Unable to dequeue ProductCollectionViewCell")
        }
        cell.configure(with: products[indexPath.row])
        return cell
    }
    
    // 컬렉션 뷰 중앙에 위치한 셀의 인덱스 감지
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let centerPoint = CGPoint(x: collectionView.center.x + collectionView.contentOffset.x, y: collectionView.center.y + collectionView.contentOffset.y)
        if let visibleIndexPath = collectionView.indexPathForItem(at: centerPoint) {
            let selectedProduct = products[visibleIndexPath.row]
            onProductSelected?(selectedProduct)
        }
    }
}

