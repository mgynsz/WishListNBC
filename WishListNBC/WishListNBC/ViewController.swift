//
//  ViewController.swift
//  WishListNBC
//
//  Created by David Jang on 4/9/24.
//

import SwiftUI
import UIKit
import CoreData

class ViewController: UIViewController {
    
    private var productsVC = ProductsVC()
    private var selectedProduct: Model?
    private var wishlistButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "WISH LIST"
        addChildVC()
        setupWishlistButton()
        fetchProducts()
    }
    
    private func addChildVC() {
        addChild(productsVC)
        view.addSubview(productsVC.view)
        productsVC.didMove(toParent: self)
        productsVC.view.frame = view.bounds
        productsVC.onProductSelected = { [weak self] product in
            self?.selectedProduct = product
        }
    }
    
    private func setupWishlistButton() {
        wishlistButton = UIButton(type: .system)
        wishlistButton.translatesAutoresizingMaskIntoConstraints = false
        wishlistButton.backgroundColor = .clear
        wishlistButton.setTitle("담기", for: .normal)
        wishlistButton.setTitleColor(.black, for: .normal)
        wishlistButton.layer.borderWidth = 1
        wishlistButton.layer.borderColor = UIColor.black.cgColor
        wishlistButton.clipsToBounds = true
        wishlistButton.addTarget(self, action: #selector(addToWishlist), for: .touchUpInside)
        view.addSubview(wishlistButton)
        
        NSLayoutConstraint.activate([
            wishlistButton.heightAnchor.constraint(equalToConstant: 48),
            wishlistButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            wishlistButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            wishlistButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc private func addToWishlist() {
        guard let productToAdd = selectedProduct else { return }
        addProductToCoreData(model: productToAdd)
        showWishlistModal()
    }
    
    private func showWishlistModal() {
        let wishlistVC = WishListVC()
        wishlistVC.wishlist = fetchProductsFromCoreData()
        wishlistVC.onWishlistUpdated = { [weak self] updatedWishlist in
            self?.saveProductsToCoreData(products: updatedWishlist)
        }
        let navController = UINavigationController(rootViewController: wishlistVC)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
    
    func fetchProductsFromCoreData() -> [Product] {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request: NSFetchRequest<Product> = Product.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching products: \(error)")
            return []
        }
    }
    
    func saveProductsToCoreData(products: [Product]) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
    private func fetchProducts() {
        Task {
            do {
                let products = try await NetworkManager.shared.getAllProduts()
                DispatchQueue.main.async {
                    self.productsVC.products = products
                    self.productsVC.collectionView.reloadData()
                    self.productsVC.collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .top)
                    self.selectedProduct = self.productsVC.products.first
                    self.wishlistButton.isEnabled = true
                }
            } catch {
                print("Error fetching products: \(error)")
            }
        }
    }
    
    func addProductToCoreData(model: Model) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request: NSFetchRequest<Product> = Product.fetchRequest()
        request.predicate = NSPredicate(format: "id == %lld", model.id)  // Int64로 조정
        
        do {
            let results = try context.fetch(request)
            if let existingProduct = results.first {
                existingProduct.quantity += 1
            } else {
                let newProduct = Product(context: context)
                newProduct.id = Int64(model.id)  // id 설정
                newProduct.title = model.title
                newProduct.price = Int64(model.price)
                newProduct.thumbnail = model.thumbnail
                newProduct.quantity = 1
            }
            try context.save()
        } catch {
            print("Failed to fetch or save product: \(error)")
        }
    }
}

struct ViewController_Previews: PreviewProvider {
    static var previews: some View {
        VCPreview { ViewController() }
    }
}

