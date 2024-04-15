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
    private var totalPrice = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTotalPriceLabel()
        setupTableView()
        fetchProductsFromCoreData()
        setupNavigationBar()
    }
    
    private func setupTotalPriceLabel() {
        totalPrice = UILabel()
        totalPrice.translatesAutoresizingMaskIntoConstraints = false
        totalPrice.backgroundColor = .white
        totalPrice.layer.borderWidth = 1
        totalPrice.layer.borderColor = UIColor.black.cgColor
        totalPrice.textColor = .black
        totalPrice.textAlignment = .center
        totalPrice.font = UIFont.systemFont(ofSize: 18)
        view.addSubview(totalPrice)
        
        NSLayoutConstraint.activate([
            totalPrice.heightAnchor.constraint(equalToConstant: 48),
            totalPrice.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            totalPrice.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            totalPrice.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 90
        tableView.register(WishListTableViewCell.self, forCellReuseIdentifier: "WishListTableViewCell")
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: totalPrice.topAnchor) // 이제 제약조건이 올바르게 작동합니다.
        ])
    }
    
    private func setupNavigationBar() {
//        navigationItem.title = "WISH LIST"
        let backButton = UIBarButtonItem(title: "< BACK", style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = .black
        navigationItem.rightBarButtonItem = backButton
    }
    
    @objc func backButtonTapped() {
        navigationController?.popToRootViewController(animated: true)
    }


    
    @objc func stepperValueChanged(_ sender: UIStepper) {
        let row = Int(sender.tag)
        guard row < wishlist.count else {
            return  // 인덱스 범위를 벗어난 경우 함수 종료
        }
        let product = wishlist[row]
        product.quantity = Int16(sender.value)  // 상품 수량 업데이트
        if let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? WishListTableViewCell {
            cell.quantityLabel.text = "Qty: \(Int(sender.value))"  // 셀 레이블 업데이트
        }
        updateProductQuantity(at: IndexPath(row: row, section: 0), quantity: Int16(sender.value))
        updateTotalPriceLabel()  // 전체 가격 업데이트
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
    
    @objc func dismissWishListVC() {
        dismiss(animated: true, completion: nil)
        onWishlistUpdated?(wishlist)
    }
    
    func fetchProductsFromCoreData() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request: NSFetchRequest<Product> = Product.fetchRequest()
        do {
            wishlist = try context.fetch(request)
            tableView.reloadData()
            updateTotalPriceLabel()
        } catch {
            print("Error fetching products: \(error)")
        }
    }
    
    func updateTotalPriceLabel() {
        let totalPriceValue = calculateTotalPrice()
        totalPrice.text = "$\(totalPriceValue.formattedWithSeparator)"
    }
    
    func calculateTotalPrice() -> Int {
        return wishlist.reduce(0) { $0 + Int($1.price) * Int($1.quantity) }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wishlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WishListTableViewCell.identifier, for: indexPath) as? WishListTableViewCell else {
            fatalError("Unable to dequeue WishListTableViewCell")
        }
        let product = wishlist[indexPath.row]
        cell.configure(with: product)
        cell.stepper.tag = indexPath.row  // 스태퍼의 태그를 여기서 설정
        cell.stepper.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .valueChanged)
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
}
