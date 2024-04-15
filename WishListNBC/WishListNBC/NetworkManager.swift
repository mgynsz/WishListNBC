//
//  NetworkManager.swift
//  WishListNBC
//
//  Created by David Jang on 4/9/24.
//

import Foundation
import UIKit

class NetworkManager {
    
    static let shared = NetworkManager()
    
    func getAllProduts() async throws -> [Model] {
        guard let url = URL(string: "https://dummyjson.com/products/") else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let productsResponse = try JSONDecoder().decode(ProductsResponse.self, from: data)
        
        return productsResponse.products
    }
}
