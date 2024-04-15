//
//  WishListVC.swift
//  WishListNBC
//
//  Created by David Jang on 4/12/24.
//

import UIKit
import CoreData

class WishListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var wishlist: [Product] = []
    var onWishlistUpdated: (([Product]) -> Void)?
    private var tableView: UITableView!
    private let productImageView = UIImageView()
    private var totalPrice = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTotalPriceLabel()
        setupTableView()
        fetchProductsFromCoreData()
        setupNavigationBar()
        
    }
    
    private func setupTableView() {
        productImageView.contentMode = .scaleAspectFit
        
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 90
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.clipsToBounds = true

        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: totalPrice.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupTotalPriceLabel() {
        totalPrice = UILabel()
        totalPrice.translatesAutoresizingMaskIntoConstraints = false
        totalPrice.backgroundColor = .white // 배경색 설정
        totalPrice.layer.borderWidth = 1
        totalPrice.layer.borderColor = UIColor.black.cgColor
        totalPrice.clipsToBounds = true
        totalPrice.textColor = .black
        totalPrice.textAlignment = .center
        totalPrice.font = UIFont.systemFont(ofSize: 18)
        
        view.addSubview(totalPrice)
        
        NSLayoutConstraint.activate([
            totalPrice.heightAnchor.constraint(equalToConstant: 48),
            totalPrice.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            totalPrice.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            totalPrice.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
        ])
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "WISH LIST"
        navigationController?.navigationBar.standardAppearance.configureWithOpaqueBackground()
        navigationController?.navigationBar.standardAppearance.backgroundColor = .white
        navigationController?.navigationBar.standardAppearance.shadowColor = .black
        
        let closeButton = UIBarButtonItem(title: "< BACK", style: .plain, target: self, action: #selector(dismissWishListVC))
        closeButton.tintColor = .black
        navigationItem.leftBarButtonItem = closeButton
    }
    
    @objc func stepperValueChanged(_ stepper: UIStepper) {
        let row = Int(stepper.tag)
        guard row < wishlist.count else {
            return  // 인덱스 범위를 벗어난 경우 함수 종료
        }
        let indexPath = IndexPath(row: row, section: 0)
        
        if let cell = tableView.cellForRow(at: indexPath),
           let quantityLabel = cell.viewWithTag(100) as? UILabel {
            quantityLabel.text = "Qty: \(Int(stepper.value))"
        }
        
        updateProductQuantity(at: indexPath, quantity: Int16(stepper.value))
        updateTotalPriceLabel()
    }
    
    func updateProductQuantity(at indexPath: IndexPath, quantity: Int16) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request: NSFetchRequest<Product> = Product.fetchRequest()
        request.predicate = NSPredicate(format: "id == %lld", wishlist[indexPath.row].id)
        
        do {
            let results = try context.fetch(request)
            if let product = results.first {
                product.quantity = quantity
                try context.save()
            }
        } catch {
            print("Error: \(error)")
        }
    }
    
    // 제품 갯수에 따라 가격을 계산하는 메서드
    func calculateTotalPrice() -> Int {
        return wishlist.reduce(0) { $0 + Int($1.price) * Int($1.quantity) }
    }
    
    func updateTotalPriceLabel() {
        let totalPriceValue = calculateTotalPrice()
        totalPrice.text = "$\(totalPriceValue.formattedWithSeparator)"
        print("Updated total price: $\(totalPriceValue)")
    }
    
    @objc private func dismissWishListVC() {
        dismiss(animated: true, completion: nil)
        onWishlistUpdated?(wishlist)
    }
    func fetchProductsFromCoreData() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request: NSFetchRequest<Product> = Product.fetchRequest()
        do {
            wishlist = try context.fetch(request)
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.updateTotalPriceLabel()  // UI 업데이트 보장
            }
        } catch {
            print("Error fetching products: \(error)")
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wishlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        configureCell(cell, at: indexPath)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let productToDelete = wishlist[indexPath.row]
            
            context.delete(productToDelete)
            wishlist.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            do {
                try context.save()
                updateTotalPriceLabel()
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    func configureCell(_ cell: UITableViewCell, at indexPath: IndexPath) {
        cell.clipsToBounds = true
        cell.selectionStyle = .none
        
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        
        let product = wishlist[indexPath.row]
        
        let thumbnailImageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 60, height: 60))
        thumbnailImageView.contentMode = .scaleAspectFit
        cell.contentView.addSubview(thumbnailImageView)
        
        if let thumbnailURL = product.thumbnail, let url = URL(string: thumbnailURL) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, let image = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    thumbnailImageView.image = image
                }
            }
            task.resume()
        }
        
        let titleLabel = UILabel()
        titleLabel.text = product.title
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(titleLabel)
        
        let quantityLabel = UILabel()
        quantityLabel.tag = 100
        quantityLabel.text = "Qty: \(product.quantity)"
        quantityLabel.font = UIFont.systemFont(ofSize: 11)
        quantityLabel.textColor = .orange
        quantityLabel.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(quantityLabel)
        
        let stepper = UIStepper()
        stepper.minimumValue = 1
        stepper.value = Double(product.quantity)
        stepper.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .valueChanged)
        stepper.translatesAutoresizingMaskIntoConstraints = false
        stepper.tag = indexPath.row  // 핵심 수정: 태그 업데이트
        cell.contentView.addSubview(stepper)
        
        // Add constraints
        NSLayoutConstraint.activate([
            thumbnailImageView.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 8),
            thumbnailImageView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: 60),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 60),
            
            titleLabel.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 16),
//            titleLabel.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
//            titleLabel.bottomAnchor.constraint(equalTo: quantityLabel.topAnchor, constant: 16),
            
            quantityLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            quantityLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 16),
//            quantityLabel.trailingAnchor.constraint(equalTo: stepper.leadingAnchor, constant: 16),
            
            stepper.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            stepper.leadingAnchor.constraint(equalTo: quantityLabel.trailingAnchor, constant: 16),
//            stepper.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor)
//            stepper.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: 8)
        ])
    }
    
}
